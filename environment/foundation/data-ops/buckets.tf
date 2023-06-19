module "gcs_bucket" {
  # Create a bucket for datasets and assign accounts

  source           = "terraform-google-modules/cloud-storage/google"
  version          = "~> 3.0"
  project_id       = module.secure-staging-project.project_id
  location         = local.default_region
  randomize_suffix = true
  prefix           = "sde"
  names            = ["cordon"]

  set_creator_roles = true
  creators          = local.data_ops_admins
}

resource "random_id" "bucket_suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "researcher_dataset" {
  for_each                    = toset(local.research_wrkspc)
  name                        = "gcs-${lower(local.default_region)}-${lower(each.value)}-${random_id.bucket_suffix.hex}"
  location                    = local.default_region
  project                     = module.secure-staging-project.project_id
  uniform_bucket_level_access = true
}