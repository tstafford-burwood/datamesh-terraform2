#----------------------
# PUB/SUB TOPIC MODULE
#----------------------

resource "google_pubsub_topic" "topic" {

  // REQUIRED

  name    = var.topic_name
  project = var.project_id

  message_storage_policy {
    allowed_persistence_regions = var.allowed_persistence_regions
  }

  // OPTIONAL

  kms_key_name = var.kms_key_name
  labels       = var.topic_labels

  // ONLY WORKS WITH GCP PROVIDER OF v3.68.0 OR GREATER
  // NEEDS SCHEMA NAME
  // CAN'T USE NULL OR ""

  # schema_settings {
  #   schema   = var.schema
  #   encoding = var.encoding
  # }
}