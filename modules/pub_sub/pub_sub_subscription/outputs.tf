#-----------------------------
# PUB/SUB SUBSCRIPTION OUTPUTS
#-----------------------------

output "subscription_name" {
  description = "Name of the subscription."
  value       = google_pubsub_subscription.subscription.name
}

output "subscription_labels" {
  description = "Labels applied to the subscription."
  value       = google_pubsub_subscription.subscription.labels
}