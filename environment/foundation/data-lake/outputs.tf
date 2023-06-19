#-------------------------------------
# DATA LAKE PROJECT OUTPUTS
#-------------------------------------

output "data_lake_project_id" {
  # tfdoc:output workspace-project
  description = "The project id"
  value       = module.data-lake-project.project_id
}

output "data_lake_project_name" {
  # tfdoc:output workspace-project
  description = "The project name"
  value       = module.data-lake-project.project_name
}

output "data_lake_project_number" {
  # tfdoc:output workspace-project
  description = "The project number."
  value       = module.data-lake-project.project_number
}

output "research_to_bucket" {
  # tfdoc:output workspace-project cloud-composer-dags
  description = "Map of researcher name to their bucket name"
  value       = { for name, bucket in google_storage_bucket.researcher_dataset : name => bucket.name }
}

output "bucket_list_custom_role_name" {
  # tfdoc:output workspace-project
  description = "Output of the custom role name"
  value       = module.bucket_list_custom_role.name
}