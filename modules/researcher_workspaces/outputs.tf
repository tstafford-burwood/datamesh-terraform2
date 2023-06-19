# Egress

output "egress_project_id" {
  description = "Project ID"
  value       = module.egress_project.project_id
}

output "egress_project_name" {
  description = "Project Name"
  value       = module.egress_project.project_name
}

output "egress_project_number" {
  # tfdoc:output workspace-project
  description = "Project Number"
  value       = module.egress_project.project_number
}

# output "initiative" {
#   # tfdoc:output Application-Integration
#   description = "Research Initiative value used in Application Integration"
#   value       = lower(replace(local.researcher_workspace_name, "-", "_"))
# }

output "external_gcs_egress_bucket" {
  # tfdoc:output workspace-project
  description = "Name of egress bucket in researcher data egress project."
  value       = module.egress_project.external_gcs_egress_bucket
}

output "external_users_vpc" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC."
  value       = var.external_users_vpc
}

# Workspace

output "workspace_project_id" {
  # tfdoc:output:consumers data-ops-project/set_researcher_dag_envs.py
  description = "Researcher workspace project id"
  value       = module.workspace_project.project_id
}

output "workspace_project_name" {
  description = "Researcher workspace project number"
  value       = module.workspace_project.project_name
}

output "workspace_project_number" {
  description = "Researcher workspace project number"
  value       = module.workspace_project.project_number
}

output "workspace_network_name" {
  description = "The name of the VPC being created"
  value       = module.workspace_project.network_name
}

output "workspace_subnets_names" {
  description = "The names of the subnets being created"
  value       = module.workspace_project.subnets_names
}

output "notebook_sa_email" {
  description = "Notebook service account"
  value       = module.workspace_project.notebook_sa_email
}

output "notebook_sa_name" {
  description = "Notebook service account fully-qualified name of the service account"
  value       = module.workspace_project.notebook_sa_name
}

output "notebook_sa_member" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "Notebook service account identity in the form `serviceAccount:{email}`"
  value       = module.workspace_project.notebook_sa_member
}

output "vm_name" {
  description = "Compute instance name"
  value       = module.workspace_project.vm_name
}

output "vm_id" {
  description = "The server-assigned unique identifier of this instance."
  value       = module.workspace_project.vm_id
}

output "data_stewards" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "List of data stewards"
  value       = module.workspace_project.data_stewards
}

output "researchers" {
  value = module.workspace_project.researchers
}

# # output "data_stewards_vpc" {
# #   # tfdoc:output:consumers foundation/vpc-sc
# #   description = "List of individual data stewards to be added to VPC Service Control perimeter."
# #   value       = var.data_stewards_vpc
# # }