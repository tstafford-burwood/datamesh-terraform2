// Storage

output "log_sink_resource_name_storage" {
  description = "The resource name of the log sink that was created."
  value       = var.create_gcs_logs_export == true ? module.gcs_logs_export[0].log_sink_resource_name : null
}

output "writer_identity_storage" {
  description = "The service account that logging uses to write log entries to the destination."
  value       = var.create_gcs_logs_export == true ? module.gcs_logs_export[0].writer_identity : null
}

output "destination_storage_name" {
  description = "The resource name for the destination Storage."
  value       = var.create_gcs_logs_export == true ? module.destination_storage[0].resource_name : null
}

// BQ

output "log_sink_resource_name_bq" {
  description = "The resource name of the log sink that was created for BQ."
  value       = var.create_bq_logs_export == true ? module.bq_logs_export[0].log_sink_resource_name : null
}

output "writer_identity_bq" {
  description = "The service account that logging uses to write log entries to the destination BQ."
  value       = var.create_bq_logs_export == true ? module.bq_logs_export[0].writer_identity : null
}

output "destination_bq_name" {
  description = "The resource name for the destination BQ."
  value       = var.create_bq_logs_export == true ? module.destination_bigquery[0].resource_name : null
}

// Pub/Sub

output "log_sink_resource_name_pubsub" {
  description = "The resource name of the log sink that was created for Pub/Sub."
  value       = var.create_pubsub_logs_export == true ? module.pubsub_logs_export[0].log_sink_resource_name : null
}

output "writer_identity_pubsub" {
  description = "The service account that logging uses to write log entries to the destination Pub/Sub."
  value       = var.create_pubsub_logs_export == true ? module.pubsub_logs_export[0].writer_identity : null
}

output "destination_pubsub_name" {
  description = "The resource name for the destination Pub/Sub."
  value       = var.create_pubsub_logs_export == true ? module.destination_pubsub[0].resource_name : null
}

// Logs Bucket

output "log_sink_resource_name_logsbucket" {
  description = "The resource name of the log sink that was created for logsbucket."
  value       = var.create_logsbucket_logs_export == true ? module.logbucket_logs_export[0].log_sink_resource_name : null
}

output "writer_identity_logsbucket" {
  description = "The service account that logging uses to write log entries to the destination logsbucket."
  value       = var.create_logsbucket_logs_export == true ? module.logbucket_logs_export[0].writer_identity : null
}

output "destination_logsbucket_name" {
  description = "The resource name for the destination logsbucket."
  value       = var.create_logsbucket_logs_export == true ? module.destination_logsbucket[0].resource_name : null
}

// Splunk

output "log_sink_resource_name_splunk" {
  description = "The resource name of the log sink that was created for Splunk."
  value       = var.create_splunk_logs_export == true ? module.splunk_logs_export[0].log_sink_resource_name : null
}

output "writer_identity_splunk" {
  description = "The service account that logging uses to write log entries to the destination logsbucket."
  value       = var.create_splunk_logs_export == true ? module.splunk_logs_export[0].writer_identity : null
}

output "destination_splunk_name" {
  description = "The resource name for the destination logsbucket."
  value       = var.create_splunk_logs_export == true ? module.destination_splunk[0].resource_name : null
}

output "pubsub_subscripter_splunk" {
  description = "Pub/Sub topic subscriber email"
  value       = var.create_splunk_logs_export == true ? module.destination_splunk[0].pubsub_subscriber : null
}

output "pubsub_subscription_name_splunk" {
  description = "Pub/Sub topic subscription name for Splunk"
  value       = var.create_splunk_logs_export == true ? module.destination_splunk[0].pubsub_subscription : null
}

output "pubsub_topic_name_splunk" {
  description = "Pub/Sub topic name for Splunk"
  value       = var.create_splunk_logs_export == true ? module.destination_splunk[0].resource_id : null
}