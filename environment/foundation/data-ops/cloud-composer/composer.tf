module "cloud_composer" {
  source  = "terraform-google-modules/composer/google//modules/create_environment_v2"
  version = "~> 3.4"

  project_id                       = local.staging_project_id
  composer_env_name                = format("%v-%v", local.environment[terraform.workspace], "composer-private")
  region                           = local.default_region
  network                          = local.staging_network_name
  subnetwork                       = local.staging_subnetwork
  pod_ip_allocation_range_name     = "kubernetes-pods"
  service_ip_allocation_range_name = "kubernetes-services"
  composer_service_account         = google_service_account.composer_sa.email
  grant_sa_agent_permission        = true
  enable_private_endpoint          = true
  use_private_environment          = true
  env_variables                    = var.env_variables
  environment_size                 = var.environment_size

  image_version = var.image_version

  master_ipv4_cidr = var.master_ipv4_cidr

  pypi_packages = var.pypi_packages

  airflow_config_overrides = {
    "webserver-rbac"                        = "True",
    "webserver-rbac_user_registration_role" = local.access_control
    # "api-auth_backend"                      = "airflow.api.auth.backend.default"
  }

  scheduler = var.scheduler
  tags      = []

  web_server                   = var.web_server
  web_server_allowed_ip_ranges = var.allowed_ip_range
  worker                       = var.worker

  depends_on = [
    time_sleep.wait_120_seconds
  ]

  # The following example specifies a 6-hour maintenance window between 01:00 and 07:00 (UTC) on Sundays, Friday, and Saturdays. The 1 January, 2021 date is ignored.
  maintenance_start_time = "2021-01-01T01:00:00Z"
  maintenance_end_time   = "2021-01-01T07:00:00Z"
  maintenance_recurrence = "FREQ=WEEKLY;BYDAY=SU,FR,SA"
}