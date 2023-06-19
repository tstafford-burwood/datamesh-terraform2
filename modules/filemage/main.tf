# START VM Instance Group
data "google_compute_image" "filemage_public_image" {
  family  = "filemage-ubuntu"
  project = "filemage-public"
}

data "google_iam_policy" "instance_read_secret" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:${var.service_account_email}",
    ]
  }
}

resource "google_compute_instance_template" "filemage" {
  depends_on = [
    google_sql_database_instance.read_replica,
    google_secret_manager_secret_version.database_password,
    google_secret_manager_secret_version.application_secret,
  ]

  project      = var.project
  name_prefix  = "filemage-app-"
  machine_type = "e2-micro"
  tags         = ["filemage-app"]

  disk {
    source_image = data.google_compute_image.filemage_public_image.self_link
  }

  network_interface {
    subnetwork = var.subnetwork
  }

  metadata = {
    startup-script = templatefile("${path.module}/scripts/initialize-application.sh", {
      pg_host  = google_sql_database_instance.main_primary.private_ip_address,
      hostname = var.filemage_domain
    })
  }

  lifecycle {
    create_before_destroy = true
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group_manager" "filemage" {
  name = "filemage-mig"

  project            = var.project
  zone               = var.zone
  base_instance_name = "filemage-app"
  target_pools       = [google_compute_target_pool.default.id]
  target_size        = 2

  version {
    instance_template = google_compute_instance_template.filemage.id
  }
}

# END VM Instance Group

# START Database
resource "random_id" "database_suffix" {
  byte_length = 4
}

resource "google_sql_database" "main" {
  name    = "filemage-db"
  project = var.project

  instance = google_sql_database_instance.main_primary.name
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
}

resource "google_sql_user" "db_user" {
  depends_on = [
    google_sql_database.main,
    google_sql_database_instance.read_replica,
  ]

  name     = "filemage"
  project  = var.project
  instance = google_sql_database_instance.main_primary.name
  password = random_password.db_password.result
}

resource "google_sql_database_instance" "main_primary" {
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]

  name                = "filemage-db-primary-${random_id.database_suffix.hex}"
  project             = var.project
  region              = var.region
  database_version    = "POSTGRES_13"
  deletion_protection = false

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = 10

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }

    database_flags {
      name  = "cloudsql.enable_pg_cron"
      value = "on"
    }
  }
}

resource "google_sql_database_instance" "read_replica" {
  project              = var.project
  region               = var.region
  name                 = "filemage-db-replica-${random_id.database_suffix.hex}"
  master_instance_name = google_sql_database_instance.main_primary.name
  database_version     = "POSTGRES_13"
  deletion_protection  = false

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size         = 10

    backup_configuration {
      enabled = false
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }


    database_flags {
      name  = "cloudsql.enable_pg_cron"
      value = "on"
    }
  }
}
# END Database

# START Load Balancer
resource "google_compute_target_pool" "default" {
  name    = "filemage-lb"
  project = var.project
  region  = var.region

  health_checks = [
    google_compute_http_health_check.default.name,
  ]
}

resource "google_compute_http_health_check" "default" {
  name         = "port-80-healthcheck"
  project      = var.project
  request_path = "/healthz"

  timeout_sec        = 1
  check_interval_sec = 1
}

resource "google_compute_address" "ip_address" {
  name         = "filemage-external-ip"
  project      = var.project
  region       = var.region
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "http" {
  project      = var.project
  region       = var.region
  name         = "filemage-http"
  target       = google_compute_target_pool.default.id
  port_range   = "80"
  ip_address   = google_compute_address.ip_address.address
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "https" {
  name         = "filemage-https"
  project      = var.project
  region       = var.region
  target       = google_compute_target_pool.default.id
  port_range   = "443"
  ip_address   = google_compute_address.ip_address.address
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "sftp" {
  name         = "filemage-sftp"
  project      = var.project
  region       = var.region
  target       = google_compute_target_pool.default.id
  port_range   = "2222"
  ip_address   = google_compute_address.ip_address.address
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "ftp" {
  name         = "filemage-ftp"
  project      = var.project
  region       = var.region
  target       = google_compute_target_pool.default.id
  port_range   = "21"
  ip_address   = google_compute_address.ip_address.address
  network_tier = "STANDARD"
}
# END Load Balancer

# START Secrets
resource "google_secret_manager_secret" "database_password" {
  secret_id = "filemage-database-password"
  project   = var.project
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "database_password" {
  secret      = google_secret_manager_secret.database_password.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret_iam_policy" "database_password_read_policy" {
  project     = google_secret_manager_secret.database_password.project
  secret_id   = google_secret_manager_secret.database_password.secret_id
  policy_data = data.google_iam_policy.instance_read_secret.policy_data
}

# The application secret is used to sign session cookies.
resource "random_string" "application_secret" {
  length  = 128
  special = true
}

resource "google_secret_manager_secret" "application_secret" {
  secret_id = "filemage-application-secret"
  project   = var.project
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "application_secret" {
  secret      = google_secret_manager_secret.application_secret.id
  secret_data = random_string.application_secret.result
}

resource "google_secret_manager_secret_iam_policy" "application_secret" {
  project     = google_secret_manager_secret.application_secret.project
  secret_id   = google_secret_manager_secret.application_secret.secret_id
  policy_data = data.google_iam_policy.instance_read_secret.policy_data
}

resource "google_secret_manager_secret" "host_key_secret" {
  secret_id = "filemage-host-key-secret"
  project   = var.project
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "tls_private_key" "filemage_host_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_secret_manager_secret_version" "host_key_secret" {
  secret      = google_secret_manager_secret.host_key_secret.id
  secret_data = tls_private_key.filemage_host_key.private_key_openssh
}

resource "google_secret_manager_secret_iam_policy" "host_key_secret" {
  project     = google_secret_manager_secret.host_key_secret.project
  secret_id   = google_secret_manager_secret.host_key_secret.secret_id
  policy_data = data.google_iam_policy.instance_read_secret.policy_data
}
# END Secrets

# START Network
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  project       = var.project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.vpc_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
# END Network

# START Firewall
resource "google_compute_firewall" "app" {
  name          = "filemage-app"
  project       = var.project
  network       = var.vpc_self_link
  priority      = "1001"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["443", "21", "2222", "80", "22"]
  }

  target_tags = ["filemage-app"]
}

# FTP clients connect directly to app VMs, bypassing load balancer.
resource "google_compute_firewall" "ftp_passive" {
  name          = "filemage-ftp-passive"
  project       = var.project
  network       = var.vpc_self_link
  priority      = "1002"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["32768-65535"]
  }

  target_tags = ["filemage-app"]
}

# END Firewall