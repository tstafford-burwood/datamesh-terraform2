output "project_id" {
  description = "Project ID"
  value       = module.project.project_id
}

output "project_number" {
  description = "Project Number"
  value       = module.project.project_number
}

output "project_name" {
  description = "Project Name"
  value       = module.project.project_name
}

output "bucket_names" {
  # tfdoc:output cloud-composer-dags
  description = "Bucket names."
  value       = { for name, bucket in google_storage_bucket.researcher_dataset : name => bucket.name }
}

output "bucket_list_custom_role_name" {
  # tfdoc:output workspace-project
  description = "Output of the custom role name"
  value       = module.bucket_list_custom_role.name
}