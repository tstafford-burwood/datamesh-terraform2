#------------------------
# CLOUD COMPOSER OUTPUTS
#------------------------

output "airflow_uri" {
  description = "URI of the Apache Airflow Web UI hosted within Cloud Composer Environment."
  value       = google_composer_environment.composer_env.config.0.airflow_uri
}

output "composer_env_name" {
  description = "Name of the Cloud Composer Environment."
  value       = google_composer_environment.composer_env.name
}

output "composer_env_id" {
  description = "ID of Cloud Composer Environment."
  value       = google_composer_environment.composer_env.id
}

output "gke_cluster" {
  description = "Google Kubernetes Engine cluster used to run the Cloud Composer Environment."
  value       = google_composer_environment.composer_env.config.0.gke_cluster
}

output "gcs_bucket" {
  description = "Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment."
  value       = google_composer_environment.composer_env.config.0.dag_gcs_prefix
}