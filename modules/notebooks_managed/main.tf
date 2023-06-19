# ----------------------------------
# DATA
# Help lookup network and subnet id
# ----------------------------------

data "google_compute_network" "network" {
  # Read the VPC network name, if provided
  count   = var.network != "" ? 1 : 0
  project = var.project
  name    = var.network
}

data "google_compute_subnetwork" "subnetwork" {
  # Lookup subnet, if network variable is provided
  count   = var.network != "" ? 1 : 0
  project = var.project
  name    = var.subnet
  region  = var.region
}

# --------------------------------------------
# Create Managed Notebooks
# --------------------------------------------

resource "random_string" "random_name" {
  length    = 4
  min_lower = 4
  special   = false
}

locals {
  member = var.access_mode == "" ? "user" : "serviceAccount"
  # Loop through all the scientist names and provision a managed notebook.
  # var.trusted_scientists has users that are defined with the IAM type such as "user:aaa@example.com", "group:bbb@example.com", "serviceAccount:ccc@example.com".
  # Therefore, we need to remove the prefix type
  format = [for name in var.trusted_scientists : replace(name, "/\\S+:/", "") if name != ""] # loop through the list of accounts and remove prefix type
}

resource "google_notebooks_runtime" "managed" {
  for_each = toset(local.format)

  name     = format("%s-mng-nbk-%s-%s", var.notebook_name_prefix, split("@", replace(each.value, "/[.'_]+/", "-"))[0], random_string.random_name.result)
  project  = var.project
  location = var.region

  access_config {
    access_type   = var.access_mode
    runtime_owner = each.value
  }

  virtual_machine {
    virtual_machine_config {
      # Deploy into either a Google Managed network or project owned VPC
      network           = var.network == "" ? "" : data.google_compute_network.network[0].self_link
      subnet            = var.network == "" ? "" : data.google_compute_subnetwork.subnetwork[0].self_link
      reserved_ip_range = var.reserved_ip_range != "" ? var.reserved_ip_range : ""
      internal_ip_only  = var.network != "" ? true : false
      shielded_instance_config {
        enable_secure_boot          = var.enable_secure_boot
        enable_vtpm                 = var.enable_vtpm
        enable_integrity_monitoring = var.enable_integrity_monitoring
      }
      machine_type = var.machine_type
      data_disk {

        initialize_params {
          disk_size_gb = var.boot_disk_size
          disk_type    = var.boot_disk_type
        }
      }
      metadata = (
        {
          terraform                  = "true"
          block-project-ssh-keys     = true
          notebook-disable-downloads = var.disable_downloads
          notebook-disable-nbconvert = var.disable_nbconvert
        }
      )
    }
  }

  software_config {
    install_gpu_driver = false
    kernels {
      repository = var.repository
      tag        = var.tag
    }
    idle_shutdown         = var.idle_shutdown
    idle_shutdown_timeout = var.idle_shutdown_timeout
  }
}