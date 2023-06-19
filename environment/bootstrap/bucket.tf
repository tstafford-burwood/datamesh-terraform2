resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "tfstate" {
  # Create a GCS bucket to store state
  # Assign autoclass with versioning enabled. Delete versions after 14 days by default
  project       = var.project_id
  name          = "terraform-state-${random_id.bucket_prefix.hex}"
  location      = var.location
  storage_class = var.storage_class

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
  force_destroy               = true
  public_access_prevention    = "enforced"

  autoclass {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 14
    }
    action {
      type = "Delete"
    }
  }
}