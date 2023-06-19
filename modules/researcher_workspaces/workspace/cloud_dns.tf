module "researcher_workspace_restricted_api_cloud_dns" {
  # This private zone is used to access the restricted Google APIs
  source = "../../cloud_dns"

  cloud_dns_domain     = "googleapis.com."
  cloud_dns_name       = "restricted-google-apis"
  cloud_dns_project_id = module.workspace_project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone for mapping calls for restricted.googleapis.com to Virtual IP addresses in the SDE."
  cloud_dns_labels                   = { "restricted-google-api-private-zone" : "${local.researcher_workspace_name}" }
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = local.workspace_restricted_api_cloud_dns_recordsets
}

#----------------------------------------------------------------------------------------------
# WORKSAPCE IAP TUNNEL CLOUD DNS ZONE MODULE
# THIS PRIVATE ZONE FOR IAP IS NEEDED TO ESTABLISH IAP TUNNEL CONNECTIVITY FROM WITHIN A GCP VM TO ANOTHER GCP VM
# https://cloud.google.com/iap/docs/securing-tcp-with-vpc-sc#configure-dns
#----------------------------------------------------------------------------------------------

module "researcher_workspace_iap_tunnel_cloud_dns" {
  source = "../../cloud_dns"

  cloud_dns_domain     = "tunnel.cloudproxy.app."
  cloud_dns_name       = "iap-tunnel-zone"
  cloud_dns_project_id = module.workspace_project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables IAP connections to be established from inside of a GCP VM so that an SSH connection to another VM can be made."
  cloud_dns_labels                   = { "iap-tunnel-private-zone" : "${local.researcher_workspace_name}" }
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = local.workspace_iap_tunnel_cloud_dns_recordsets
}

module "researcher_workspace_artifact_registry_cloud_dns" {
  # This private zone is used to access the Artifact Registry
  source = "../../cloud_dns"

  cloud_dns_domain     = "pkg.dev."
  cloud_dns_name       = "artifact-registry-zone"
  cloud_dns_project_id = module.workspace_project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Artifact Registry domain."
  cloud_dns_labels                   = { "artifact-registry-private-zone" : "${local.researcher_workspace_name}" }
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = local.workspace_artifact_registry_cloud_dns_recordsets
}

module "researcher_workspace_container_registry_cloud_dns" {
  # This private zone is used to access Container Registry
  source = "../../cloud_dns"

  cloud_dns_domain     = "gcr.io."
  cloud_dns_name       = "container-registry-zone"
  cloud_dns_project_id = module.workspace_project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Container Registry domain."
  cloud_dns_labels                   = { "container-registry-private-zone" : "${local.researcher_workspace_name}" }
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = local.workspace_container_registry_cloud_dns_recordsets
}

#----------------------------------------------------------------------------------------------
# Three different private DNS Zones must be created
# https://cloud.google.com/vertex-ai/docs/workbench/user-managed/service-perimeter
#----------------------------------------------------------------------------------------------

module "researcher_workspace_notebook_api_cloud_dns" {
  # This private zone is used to access user-manged Notebooks API
  source = "../../cloud_dns"

  cloud_dns_domain     = "*.notebooks.googleapis.com."
  cloud_dns_name       = "notebook-api-zone"
  cloud_dns_project_id = module.workspace_project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Notebook API."
  cloud_dns_labels                   = { "notebook-api-private-zone" : "${local.researcher_workspace_name}" }
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = local.workspace_notebook_api_cloud_dns_recordsets
}

module "researcher_workspace_notebook_cloud_cloud_dns" {
  # This private zone is used to access user-manged Notebooks CLoud API
  source = "../../cloud_dns"

  cloud_dns_domain     = "*.notebooks.cloud.google.com."
  cloud_dns_name       = "notebook-cloud-zone"
  cloud_dns_project_id = module.workspace_project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Notebook Cloud."
  cloud_dns_labels                   = { "notebook-cloud-private-zone" : "${local.researcher_workspace_name}" }
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = local.workspace_notebook_cloud_cloud_dns_recordsets
}

module "researcher_workspace_notebook_usercontent_cloud_dns" {
  # This private zone is used to access user-manged Notebooks Usercontent
  source = "../../cloud_dns"

  cloud_dns_domain     = "*.notebooks.googleusercontent.com."
  cloud_dns_name       = "notebook-usercontent-zone"
  cloud_dns_project_id = module.workspace_project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Notebook User Content."
  cloud_dns_labels                   = { "notebook-usercontent-private-zone" : "${local.researcher_workspace_name}" }
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = local.workspace_notebook_usercontent_cloud_dns_recordsets
}