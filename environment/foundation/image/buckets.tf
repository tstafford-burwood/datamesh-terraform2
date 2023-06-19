resource "random_id" "bucket_suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "bucket" {
  for_each                    = toset(local.research_wrkspc)
  name                        = "gcs-${lower(local.image_default_region)}-${lower(each.value)}-scripts-${random_id.bucket_suffix.hex}"
  location                    = local.image_default_region
  project                     = module.image-project.project_id
  uniform_bucket_level_access = true
}