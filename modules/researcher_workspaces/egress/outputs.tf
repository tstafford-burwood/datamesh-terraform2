output "project_id" {
  description = "Project ID"
  value       = module.researcher-data-egress-project.project_id
}

output "project_name" {
  description = "Project Name"
  value       = module.researcher-data-egress-project.project_name
}

output "project_number" {
  # tfdoc:output workspace-project
  description = "Project Number"
  value       = module.researcher-data-egress-project.project_number
}

output "initiative" {
  # tfdoc:output Application-Integration
  description = "Research Initiative value used in Application Integration"
  value       = lower(replace(local.researcher_workspace_name, "-", "_"))
}

output "external_gcs_egress_bucket" {
  # tfdoc:output workspace-project
  description = "Name of egress bucket in researcher data egress project."
  value       = module.gcs_bucket_researcher_data_egress.name
}

output "external_users_vpc" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC."
  value       = var.external_users_vpc
}

# output "client_id" {
#   description = "Client ID for Cloud Composer"
#   value       = trimprefix(regex("[A-Za-z0-9-]*\\.apps\\.googleusercontent\\.com", data.http.webui.response_headers["X-Auto-Login"]), "253D")
# }