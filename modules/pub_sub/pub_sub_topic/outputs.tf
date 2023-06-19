#----------------------
# PUB/SUB TOPIC OUTPUTS
#----------------------

output "topic_name" {
  description = "Pub/Sub topic name."
  value       = google_pubsub_topic.topic.name
}

output "topic_labels" {
  description = "Pub/Sub label as a key:value pair."
  value       = google_pubsub_topic.topic.labels
}