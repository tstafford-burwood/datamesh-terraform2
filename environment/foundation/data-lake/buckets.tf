resource "random_id" "bucket_suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "researcher_dataset" {
  for_each                    = toset(local.research_wrkspc)
  name                        = "gcs-${lower(local.default_region)}-${lower(each.value)}-${random_id.bucket_suffix.hex}"
  location                    = local.default_region
  project                     = module.data-lake-project.project_id
  uniform_bucket_level_access = true



  retention_policy {
    retention_period = 86400 # Period of time in seconds
  }
}