/*************************************
  Send logs to the Splunk Pub/Sub Topic
************************************/

module "splunk_logs_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  count = var.create_splunk_logs_export ? 1 : 0

  destination_uri        = module.destination_splunk[0].destination_uri
  filter                 = var.main_logs_filter
  log_sink_name          = var.splunk_log_sink_name
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = var.parent_resource_type
  unique_writer_identity = true
  include_children       = var.include_children
}

/*************************************
  Create the Splunk Pub/Sub Topics in the project
************************************/

module "destination_splunk" {
  source  = "terraform-google-modules/log-export/google//modules/pubsub"
  version = "~> 7.0"

  count = var.create_splunk_logs_export ? 1 : 0

  project_id               = module.project-factory.project_id
  topic_name               = var.splunk_topic_name
  log_sink_writer_identity = module.splunk_logs_export[0].writer_identity
  create_push_subscriber   = var.splunk_create_push_subscriber
  create_subscriber        = true

  topic_labels        = var.splunk_topic_labels
  subscription_labels = var.splunk_subscription_labels
}

resource "google_project_iam_custom_role" "consumer" {
  count = var.create_splunk_logs_export ? 1 : 0

  project = module.project-factory.project_id

  role_id     = "SplunkSink"
  title       = "Splunk Sink"
  description = "Grant Splunk Addon for GCP permission to see the project and PubSub subscription"

  permissions = [
    "pubsub.subscriptions.list",
    "resourcemanager.projects.get",
  ]
}

resource "google_project_iam_member" "consumer" {
  count = var.create_splunk_logs_export ? 1 : 0

  project = module.project-factory.project_id
  role    = google_project_iam_custom_role.consumer[0].id
  member  = "serviceAccount:${module.destination_splunk[0].pubsub_subscriber}"
}

resource "google_pubsub_subscription_iam_member" "consumer" {
  count = var.create_splunk_logs_export ? 1 : 0

  project      = module.project-factory.project_id
  subscription = module.destination_splunk[0].pubsub_subscription
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${module.destination_splunk[0].pubsub_subscriber}"
}