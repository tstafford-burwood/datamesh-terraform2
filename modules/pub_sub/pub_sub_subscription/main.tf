#----------------------------
# PUB/SUB SUBSCRIPTION MODULE
#----------------------------

resource "google_pubsub_subscription" "subscription" {

  // REQUIRED

  name    = var.subscription_name
  project = var.project_id
  topic   = var.subscription_topic_name

  // OPTIONAL

  ack_deadline_seconds       = var.ack_deadline_seconds
  enable_message_ordering    = var.enable_message_ordering
  filter                     = var.filter
  labels                     = var.subscription_labels
  message_retention_duration = var.message_retention_duration
  retain_acked_messages      = var.retain_acked_messages

  dead_letter_policy {
    dead_letter_topic     = var.dead_letter_topic
    max_delivery_attempts = var.max_delivery_attempts
  }

  expiration_policy {
    ttl = var.expiration_policy_ttl
  }

  push_config {
    oidc_token {
      service_account_email = var.service_account_email
      audience              = var.audience
    }
    push_endpoint = var.push_endpoint
    attributes    = var.push_attributes
  }

  retry_policy {
    minimum_backoff = var.minimum_backoff
    maximum_backoff = var.maximum_backoff
  }
}