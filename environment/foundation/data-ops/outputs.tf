output "staging_project_id" {
  # tfdoc:output: consumers composer
  description = "Project ID"
  value       = module.secure-staging-project.project_id
}

output "staging_project_name" {
  description = "Project Name"
  value       = module.secure-staging-project.project_name
}

output "staging_project_number" {
  # tfdoc:output: consumers composer
  description = "Project Number"
  value       = module.secure-staging-project.project_number
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.vpc.network_name
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.vpc.subnets_names
}

output "subnets_secondary_ranges" {
  description = "The secondary ranges associated with these subnets."
  value       = module.vpc.subnets_secondary_ranges
}

output "subnets_regions" {
  description = "The region where the subnets will be created."
  value       = module.vpc.subnets_regions
}

output "vpc_access_connector_name" {
  # tfdoc:output: consumers workspaces
  description = "Name of the VPC Serverless connector"
  value       = google_vpc_access_connector.connector.*.name
}

output "vpc_access_connector_id" {
  # tfdoc:output: consumers workspaces
  description = "ID of the VPC Serverless connector. format: `projects/{{project}}/locations/{{region}}/connectors/{{name}}`"
  value       = google_vpc_access_connector.connector.*.id
}

output "custom_role_name" {
  description = "The name of the role in the format projects/{{project}}/roles/{{role_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings."
  value       = module.staging_project_iam_custom_role.name
}

output "custom_role_id" {
  description = "The role_id name."
  value       = module.staging_project_iam_custom_role.role_id
}

// DLP Outputs

output "dlp_inspect_name" {
  description = "The resource name of the inspect template."
  value       = google_data_loss_prevention_inspect_template.dlp_hipaa_inspect_template.name
}

output "dlp_inspect_id" {
  description = "An identifier for the inspect template."
  value       = google_data_loss_prevention_inspect_template.dlp_hipaa_inspect_template.id
}

output "dlp_deid_name" {
  description = "The resource name of the de-id template."
  value       = google_data_loss_prevention_deidentify_template.basic.name
}

output "dlp_deid_id" {
  description = "The resource name of the de-id template."
  value       = google_data_loss_prevention_deidentify_template.basic.id
}

// GCS Bucket Names

output "csv_buckets_map" {
  description = "Bucket resoures by name"
  value       = module.gcs_bucket.buckets_map
}

output "csv_names_list" {
  # tfdoc:output consumers workspace egress
  description = "List of bucket names"
  value       = module.gcs_bucket.names_list
}

output "research_to_bucket" {
  # tfdoc:output workspace-project cloud-composer-dags
  description = "Map of researcher name to their bucket name"
  value       = { for name, bucket in google_storage_bucket.researcher_dataset : name => bucket.name }
}