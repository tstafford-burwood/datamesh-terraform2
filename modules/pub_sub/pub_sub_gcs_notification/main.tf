#--------------------------------
# PUB/SUB GCS NOTIFICATION MODULE
#--------------------------------

resource "google_storage_notification" "notification" {

  // REQUIRED
  bucket         = var.bucket_name
  payload_format = var.payload_format
  topic          = var.pub_sub_topic

  // OPTIONAL
  custom_attributes  = var.custom_attributes
  event_types        = var.event_types
  object_name_prefix = var.object_name_prefix
}