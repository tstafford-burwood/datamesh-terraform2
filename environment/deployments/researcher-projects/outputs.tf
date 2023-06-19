# Egress

output "egress_project_id" {
  description = "Project ID"
  value       = module.workspace_1.egress_project_id
}

output "egress_project_name" {
  description = "Project Name"
  value       = module.workspace_1.egress_project_name
}

output "egress_project_number" {
  # tfdoc:output workspace-project
  description = "Project Number"
  value       = module.workspace_1.egress_project_number
}

output "external_gcs_egress_bucket" {
  # tfdoc:output workspace-project
  description = "Name of egress bucket in researcher data egress project."
  value       = module.workspace_1.external_gcs_egress_bucket
}

output "external_users" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC."
  value       = module.workspace_1.external_users_vpc
}


# WORKSPACE
output "data_stewards" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "List of data stewards"
  value       = module.workspace_1.data_stewards
}

output "researchers" {
  description = "List of researchers"
  value       = module.workspace_1.researchers
}


output "workspace_1_id" {
  # tfdoc:output:consumers data-ops-project/set_researcher_dag_envs.py
  description = "Researcher workspace project id"
  value       = module.workspace_1.workspace_project_id
}

output "workspace_1_name" {
  description = "Researcher workspace project number"
  value       = module.workspace_1.workspace_project_name
}

output "workspace_1_number" {
  description = "Researcher workspace project number"
  value       = module.workspace_1.workspace_project_number
}

output "notebook_sa_member" {
  # tfdoc:output:consumers foundation/vpc-sc
  description = "Notebook service account identity in the form `serviceAccount:{email}`"
  value       = module.workspace_1.notebook_sa_member
}

output "vm_name" {
  description = "Compute instance name"
  value       = var.num_instances != 0 ? module.workspace_1.vm_name : null
}