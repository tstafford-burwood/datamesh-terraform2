#---------------------------------------
# SINGLE VM INSTANCE MODULE - PRIVATE IP
#---------------------------------------

resource "google_compute_instance" "single_vm_instance" {

  allow_stopping_for_update = var.allow_stopping_for_update
  description               = var.vm_description
  desired_status            = var.desired_status
  deletion_protection       = var.deletion_protection
  labels                    = var.labels
  metadata                  = var.metadata
  metadata_startup_script   = var.metadata_startup_script
  project                   = var.project_id
  machine_type              = var.machine_type
  name                      = var.vm_name
  tags                      = var.tags
  zone                      = var.zone

  boot_disk {
    auto_delete       = var.auto_delete_disk
    device_name       = var.device_name
    mode              = var.disk_mode
    kms_key_self_link = var.kms_key_self_link
    source            = var.source_disk

    dynamic "initialize_params" {
      for_each = var.initialize_params
      content {
        size  = lookup(initialize_params.value, "vm_disk_size", null)
        type  = lookup(initialize_params.value, "vm_disk_type", null)
        image = lookup(initialize_params.value, "vm_disk_image", null)
      }
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    network_ip = var.network_ip
  }

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }
}