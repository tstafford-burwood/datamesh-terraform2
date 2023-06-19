module "pubsub_appint_trigger_approval" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 5.0"

  create_topic = true
  project_id   = module.secure-staging-project.project_id
  topic        = format("%s", "application-integration-trigger-approval")
}

module "pubsub_appint_trigger_results" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 5.0"

  create_topic = true
  project_id   = module.secure-staging-project.project_id
  topic        = format("%s", "application-integration-trigger-results")
}

# ---

output "pubsub_trigger_appint_approval" {
  description = "Pub/Sub for DAGs to trigger Application Integration approval"
  value       = module.pubsub_appint_trigger_approval.topic
}

output "pubsub_trigger_appint_results" {
  description = "Pub/Sub for DAG to trigger Application Integration results"
  value       = module.pubsub_appint_trigger_results.topic
}