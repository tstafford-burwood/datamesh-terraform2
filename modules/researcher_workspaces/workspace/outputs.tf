output "project_id" {
  # tfdoc:output:consumers data-ops-project/set_researcher_dag_envs.py
  description = "Researcher workspace project id"
  value       = module.workspace_project.project_id
}

output "project_name" {
  description = "Researcher workspace project number"
  value       = module.workspace_project.project_name
}

output "project_number" {
  description = "Researcher workspace project number"
  value       = module.workspace_project.project_number
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.workspace_vpc.network_name
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.workspace_vpc.subnets_names
}

output "notebook_sa_email" {
  description = "Notebook service account"
  value       = google_service_account.notebook_sa.email
}

output "notebook_sa_name" {
  description = "Notebook service account fully-qualified name of the service account"
  value       = google_service_account.notebook_sa.name
}

output "notebook_sa_member" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "Notebook service account identity in the form `serviceAccount:{email}`"
  value       = google_service_account.notebook_sa.member
}

output "vm_name" {
  description = "Compute instance name"
  value       = module.researcher_workspace_deeplearning_vm_private_ip.*.name
}

output "vm_id" {
  description = "The server-assigned unique identifier of this instance."
  value       = module.researcher_workspace_deeplearning_vm_private_ip.*.instance_id
}

output "data_stewards" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "List of data stewards"
  value       = var.data_stewards
}

output "researchers" {
  value = var.researchers
}

# output "data_stewards_vpc" {
#   # tfdoc:output:consumers foundation/vpc-sc
#   description = "List of individual data stewards to be added to VPC Service Control perimeter."
#   value       = var.data_stewards_vpc
# }