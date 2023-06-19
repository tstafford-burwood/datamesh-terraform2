module "researcher_workspace_deeplearning_vm_private_ip" {
  count  = var.num_instances > 0 ? var.num_instances : 0
  source = "../../compute_vm_instance/private_ip_instance"

  project_id                = module.workspace_project.project_id
  allow_stopping_for_update = true
  vm_description            = "Workspace VM created with Terraform"
  desired_status            = "RUNNING"
  deletion_protection       = false
  labels = {
    "${local.researcher_workspace_name}" : "deep-learning-vm"
  }
  machine_type = var.instance_machine_type
  vm_name      = "${local.researcher_workspace_name}-${var.instance_name}-${count.index}"
  tags         = var.instance_tags
  zone         = "${var.region}-b"

  initialize_params = [
    {
      vm_disk_size  = 100
      vm_disk_type  = "pd-standard"
      vm_disk_image = "${local.imaging_project_id}/${var.golden_image_version}" # Note an image must exist   
      #vm_disk_image = "${local.imaging_project_id}/${data.google_compute_image.deep_learning_image[0].name}" # Note an image must exist      
    }
  ]
  auto_delete_disk = true

  subnetwork = module.workspace_vpc.subnets_self_links[0]
  network_ip = "" // KEEP AS AN EMPTY STRING FOR AN AUTOMATICALLY ASSIGNED PRIVATE IP

  service_account_email  = google_service_account.notebook_sa.email
  service_account_scopes = ["cloud-platform"]

  enable_secure_boot          = true
  enable_vtpm                 = true
  enable_integrity_monitoring = true

  metadata = var.metadata
}

resource "google_compute_resource_policy" "snapshot_schedule" {
  # Create a snapshot schedule
  count       = var.num_instances > 0 ? 1 : 0
  project     = module.workspace_project.project_id
  name        = "disk-snapshot-schedule"
  description = "Managed by Terraform."
  region      = var.region
  snapshot_schedule_policy {
    schedule {
      // The policy will execute every Nth day at the specified time.
      daily_schedule {
        days_in_cycle = var.snapshot_days_in_cycle
        start_time    = var.snapshot_start_time # UTC format
      }
    }
    retention_policy {
      // Retention policy applied to snapshots created by this resource policy.
      max_retention_days    = var.snapshot_max_retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
  }
}


resource "google_compute_disk_resource_policy_attachment" "attachment" {
  count   = var.num_instances > 0 ? 1 : 0
  project = module.workspace_project.project_id
  name    = google_compute_resource_policy.snapshot_schedule[count.index].name
  disk    = module.researcher_workspace_deeplearning_vm_private_ip[count.index].name
  zone    = "${var.region}-b"
}


resource "local_file" "loginscript_bat" {
  # Create the file based off of the template file
  filename = "./scripts/research.bat"
  content = templatefile("${path.module}/scripts/loginscript.bat.tpl", {
    PROJECT_ID                = module.workspace_project.project_id
    RESEARCHER_WORKSPACE_NAME = local.researcher_workspace_name
    REGION                    = var.region
  })
}

resource "google_storage_bucket_object" "loginscript" {
  # Upload script to the appropriate bucket
  bucket = lookup(local.imaging_bucket, local.researcher_workspace_name, "")
  name   = "loginscript.zip"
  source = local_file.loginscript_bat.filename
}

# ---

resource "google_storage_bucket_object" "readme" {
  # Upload README to the appropriate bucket
  bucket = module.gcs_bucket_shared.name
  name   = "README.md"
  source = local_file.readme.filename
}

resource "local_file" "readme" {
  # Create a README file in the researchers GCS bucket to know Data Lake ID and bucket
  filename = "./scripts/README.md"
  content = templatefile("${path.module}/scripts/README.md.tpl", {
    DATALAKE_PROJECT_ID = local.data_lake_id
    DATALAKE_BUCKET     = lookup(local.data_lake_bucket, local.researcher_workspace_name, "")
    SHARED_BUCKET       = module.gcs_bucket_shared.name
  })
}
