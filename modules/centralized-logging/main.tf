module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.2"

  name              = var.project_name
  project_id        = var.project_id
  random_project_id = var.random_project_id
  org_id            = var.org_id
  billing_account   = var.billing_account
  folder_id         = var.folder_id
  activate_apis     = var.activate_apis
  create_project_sa = var.create_project_sa

  auto_create_network = false
  labels              = var.project_labels
}

/*************************************
  Send logs to a GCS bucket
************************************/
module "gcs_logs_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  count = var.create_gcs_logs_export ? 1 : 0

  destination_uri        = module.destination_storage[0].destination_uri
  filter                 = var.all_logs_filter
  log_sink_name          = var.log_sink_name_storage
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = var.parent_resource_type
  unique_writer_identity = true
  include_children       = var.include_children
}

/*************************************
  Create the GCS bucket in the project
************************************/

module "destination_storage" {
  source  = "terraform-google-modules/log-export/google//modules/storage"
  version = "~> 7.0"

  count = var.create_gcs_logs_export ? 1 : 0

  project_id               = module.project-factory.project_id
  storage_bucket_name      = var.storage_bucket_name
  log_sink_writer_identity = module.gcs_logs_export[0].writer_identity

  uniform_bucket_level_access = true
  location                    = var.dest_storage_location
  force_destroy               = var.force_destroy
  versioning                  = var.versioning
  storage_class               = var.storage_class
  storage_bucket_labels       = var.storage_bucket_labels

  lifecycle_rules = var.lifecycle_rules
}

/*************************************
  Send logs to the BQ Dataset
************************************/

module "bq_logs_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  count = var.create_bq_logs_export ? 1 : 0

  destination_uri        = module.destination_bigquery[0].destination_uri
  filter                 = var.main_logs_filter
  log_sink_name          = var.bq_log_sink_name
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = var.parent_resource_type
  unique_writer_identity = true
  include_children       = var.include_children
}

/*************************************
  Create the BQ dataset in the project
************************************/

module "destination_bigquery" {
  source  = "terraform-google-modules/log-export/google//modules/bigquery"
  version = "~> 7.0"

  count = var.create_bq_logs_export ? 1 : 0

  project_id               = module.project-factory.project_id
  dataset_name             = var.dataset_name
  description              = var.bq_dataset_description
  log_sink_writer_identity = module.bq_logs_export[0].writer_identity
  location                 = var.bq_location

  expiration_days            = var.expiration_days
  partition_expiration_days  = var.partition_expiration_days
  delete_contents_on_destroy = var.delete_contents_on_destroy
}

/*************************************
  Send logs to the Pub/Sub Topic
************************************/

module "pubsub_logs_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  count = var.create_pubsub_logs_export ? 1 : 0

  destination_uri        = module.destination_pubsub[0].destination_uri
  filter                 = var.main_logs_filter
  log_sink_name          = var.pubsub_log_sink_name
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = var.parent_resource_type
  unique_writer_identity = true
  include_children       = var.include_children
}

/*************************************
  Create the Pub/Sub Topics in the project
************************************/

module "destination_pubsub" {
  source  = "terraform-google-modules/log-export/google//modules/pubsub"
  version = "~> 7.0"

  count = var.create_pubsub_logs_export ? 1 : 0

  project_id               = module.project-factory.project_id
  topic_name               = var.topic_name
  log_sink_writer_identity = module.pubsub_logs_export[0].writer_identity
  create_push_subscriber   = var.create_push_subscriber

  topic_labels        = var.topic_labels
  subscription_labels = var.subscription_labels
}


/*************************************
  Send logs to the Log Bucket
************************************/

module "logbucket_logs_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  count = var.create_logsbucket_logs_export ? 1 : 0

  destination_uri        = module.destination_logsbucket[0].destination_uri
  filter                 = var.all_logs_filter
  log_sink_name          = var.logsbucket_log_sink_name
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = var.parent_resource_type
  unique_writer_identity = true
  include_children       = var.include_children
}

/*************************************
  Create the Log Bucket in the project
************************************/

module "destination_logsbucket" {
  source  = "terraform-google-modules/log-export/google//modules/logbucket"
  version = "~> 7.0"

  count = var.create_logsbucket_logs_export ? 1 : 0

  project_id               = module.project-factory.project_id
  name                     = var.logsbucket_name
  location                 = var.logsbucket_location
  log_sink_writer_identity = module.logbucket_logs_export[0].writer_identity

  retention_days = var.logsbucket_retention_days
}

