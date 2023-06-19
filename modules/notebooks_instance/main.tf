# ----------------------------------
# DATA
# ----------------------------------

data "google_compute_network" "network" {
  # Read the VPC network name
  project = var.project
  name    = var.network
}

data "google_compute_subnetwork" "subnetwork" {
  project = var.project
  name    = var.subnet
  region  = var.region
}

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
}

# Append all resource names to help with testing
# buckets must be all lowercase for buckets
resource "random_string" "random_name" {
  length    = 4
  min_lower = 4
  special   = false
}

# -----------------------------------------
# Create GCS Bucket and IAM
# -----------------------------------------

# module "bootstrap" {
#   source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
#   version = "~> 3.0"

#   project_id    = var.project
#   name          = format("ai-notebook-scripts-%s", random_string.random_name.result)
#   location      = var.region
#   force_destroy = true
# }

# # IAM for the AI Platform user service account to read the post startup script.
# resource "google_storage_bucket_iam_member" "member" {
#   bucket = module.bootstrap.bucket.name
#   role   = "roles/storage.objectViewer"
#   member = "serviceAccount:${google_service_account.sa_p_notebook_compute.email}"
# }

# resource "google_storage_bucket_object" "postscript" {
#   name   = "post_startup_script.sh"
#   source = "${path.module}/bootstrap_files/post_startup_script.sh"
#   bucket = module.bootstrap.bucket.name
# }


# --------------------------------------------
# Create Notebooks
# --------------------------------------------

resource "google_notebooks_instance" "instance" {
  for_each = toset(var.trusted_scientists)

  name            = format("%s-nbk-%s-%s", var.notebook_name_prefix, split("@", replace(each.value, "/[.'_]+/", "-"))[0], random_string.random_name.result)
  project         = var.project
  location        = data.google_compute_zones.available.names[0] # pick the first available zone
  machine_type    = var.machine_type
  service_account = google_service_account.sa_p_notebook_compute.email

  metadata = {
    terraform                  = "true"
    proxy-mode                 = "mail"
    proxy-user-mail            = each.value
    notebook-disable-root      = var.disable_root
    notebook-disable-downloads = var.disable_downloads
    notebook-disable-nbconvert = var.disable_nbconvert
    notebook-disable-terminal  = var.disable_terminal
    serial-port-enable         = "FALSE"
    block-project-ssh-keys     = "TRUE"
  }
  #   container_image {
  #     repository = "gcr.io/deeplearning-platform-release/base-cpu"
  #     tag        = "latest"
  #   }
  vm_image {
    project      = var.vm_image_project
    image_family = var.image_family
  }

  instance_owners = [each.value]

  install_gpu_driver = true
  boot_disk_type     = var.boot_disk_type
  boot_disk_size_gb  = var.boot_disk_size

  data_disk_type    = var.data_disk_size_gb == 0 ? null : var.data_disk_type
  data_disk_size_gb = var.data_disk_size_gb == 0 ? null : var.data_disk_size_gb

  # only allow network with private ip
  no_public_ip = var.no_public_ip

  # If true, forces to use an SSH tunnel
  no_proxy_access = var.no_proxy_access

  network = data.google_compute_network.network.id
  subnet  = data.google_compute_subnetwork.subnetwork.id
}