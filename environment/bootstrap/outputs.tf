output "org_id" {
  description = "Org ID to enter tino [constants.tf]() file"
  value       = var.org_id
}

output "automation_project_id" {
  description = "Automation Project ID to enter into [constants.tf]() file"
  value       = var.project_id
}

output "cloudbuild_service_account" {
  description = "Cloud Build Service account id to enter into [constants.tf]() file"
  value       = "${data.google_project.cloudbuild_project.number}@cloudbuild.gserviceaccount.com"
}

output "billing_account_id" {
  description = "Billing Account ID to enter into [constants.tf]() file"
  value       = data.google_billing_account.billing_id.id
}

output "sde_folder_id" {
  description = "Parent folder id to enter into [constants.tf]() file"
  value       = trimprefix(google_folder.parent.id, "folders/")
}

output "terraform_state_bucket" {
  description = "The GCS bucket name to enter into the [constants.tf]() file"
  value       = trimprefix(google_storage_bucket.tfstate.url, "gs://")
}

output "branch_name" {
  value = element(split("/", var.git_ref), 2)
}