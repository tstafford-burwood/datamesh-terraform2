#------------------------
# CLOUD COMPOSER OUTPUTS
#------------------------

output "airflow_uri" {
  description = "URI of the Apache Airflow Web UI hosted within the Cloud Composer Environment."
  value       = module.cloud_composer.airflow_uri
}

output "composer_env_name" {
  description = "Name of the Cloud Composer Environment."
  value       = module.cloud_composer.composer_env_name
}

output "composer_env_id" {
  description = "ID of Cloud Composer Environment."
  value       = module.cloud_composer.composer_env_id
}

output "gke_cluster" {
  description = "Google Kubernetes Engine cluster used to run the Cloud Composer Environment."
  value       = module.cloud_composer.gke_cluster
}

output "gcs_bucket" {
  description = "Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment."
  value       = module.cloud_composer.gcs_bucket
}

output "dag_bucket_name" {
  # tfdoc:output: cloud-composer cloud build workspace
  description = "Google cloud storage bucket name only without suffix"
  value       = trimsuffix(module.cloud_composer.gcs_bucket, "/dags")
}

output "composer_version" {
  # tfdoc:output: cloud-composer cloud build workspace
  description = "The version of composer that is deployed."
  value       = var.image_version
}

#------------------------
# CLOUD COMPOSER SA OUTPUTS
#------------------------

output "id" {
  description = "Cloud Composer account IAM-format email."
  value       = google_service_account.composer_sa.id
}

output "email" {
  # tfdoc:output: consumers cloud-composer, egress, workspaces
  description = "Cloud Composer service account email."
  value       = google_service_account.composer_sa.email
}

output "name" {
  # tfdoc:output consumers cloud-composer
  description = "Cloud Composer Service account resource (for single use)."
  value       = google_service_account.composer_sa.name
}