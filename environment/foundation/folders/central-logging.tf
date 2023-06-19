locals {
  org_id          = module.constants.value.org_id
  billing_account = module.constants.value.billing_account_id
  default_region  = module.constants.value.default_region
  folder_id       = google_folder.environment.folder_id
}

resource "random_id" "random_suffix" {
  byte_length = 2
}

module "centralized_logging" {
  source = "../../../modules/centralized-logging"

  org_id             = local.org_id
  billing_account    = local.billing_account
  folder_id          = local.folder_id
  project_name       = format("%s-%s", local.environment[terraform.workspace], "central-logging")
  parent_resource_id = local.folder_id

  // Storage
  storage_bucket_name   = format("fldr-%s-%s-%s", lower(var.folder_name), "sink-gcs", random_id.random_suffix.hex)
  dest_storage_location = local.default_region

  // Pub/Sub
  topic_name = format("fldr-%s-%s-%s", lower(var.folder_name), "sink-pubsub", random_id.random_suffix.hex)

  //BQ
  create_bq_logs_export = false

  // Logs Bucket
  create_logsbucket_logs_export = false
}