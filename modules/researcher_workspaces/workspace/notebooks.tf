# module "user_managed_notebook" {
#   # Each trusted scientist will get their own notebook
#   source = "../../modules/notebooks_instance"

#   network            = module.workspace_vpc.network_name
#   project            = module.workspace_project.project_id
#   region             = local.region
#   subnet             = module.workspace_vpc.subnets_names[0]
#   trusted_scientists = var.unresearchers
# }

module "managed_notebooks" {
  # Each trusted scientist will get their own notebook
  source = "../../notebooks_managed"

  count = var.deploy_notebook ? 1 : 0

  project               = module.workspace_project.project_id
  region                = local.region
  network               = module.workspace_vpc.network_name
  subnet                = module.workspace_vpc.subnets_names[0]
  idle_shutdown_timeout = 180
  trusted_scientists    = ["serviceAccount:${google_service_account.notebook_sa.email}"]
  reserved_ip_range     = module.private_access.google_compute_global_address_name
  access_mode           = "SERVICE_ACCOUNT"
}

module "private_access" {
  # Managed notebooks need a private access VPC connection between this project and a Google project
  source = "../../private_access"

  project_id    = module.workspace_project.project_id
  vpc_network   = module.workspace_vpc.network_name
  address       = "10.148.224.0"
  prefix_length = "24"
}

# -----------------------------------------------------
# Outputs
# -----------------------------------------------------

# output "notebook_instances" {
#   description = "A list of notebooks created (vm names)"
#   value       = module.ai_notebook.notebook_instances
# }

# output "user_proxy_uri" {
#   description = "A map of user to their proxy uri."
#   value       = module.ai_notebook.user_proxy_uri
# }

# output "user_instance" {
#   description = "A map of user to instance."
#   value       = module.ai_notebook.user_instance
# }

output "managed_notebook_proxy_uri" {
  description = "Managed notebook proxy uri"
  value       = var.deploy_notebook ? module.managed_notebooks[0].proxy_uri : null
}