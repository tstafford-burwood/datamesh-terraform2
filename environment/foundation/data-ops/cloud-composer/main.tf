#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../../../foundation/constants"
}

#----------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
#----------------------------------------------------------------------------

data "terraform_remote_state" "ingress_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ingress"
  }
}

data "terraform_remote_state" "data_ops_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ops"
  }
}

data "terraform_remote_state" "data_lake_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-lake"
  }
}

data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

data "terraform_remote_state" "cloud-composer" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/cloud-composer"
  }
}

data "google_compute_zones" "available" {
  project = local.staging_project_id
  region  = local.default_region
}

#----------------------------------------------------------------------------
# SET LOCALS VALUES
#----------------------------------------------------------------------------

locals {
  org_id                 = module.constants.value.org_id
  billing_account_id     = module.constants.value.billing_account_id
  foundation_folder_id   = data.terraform_remote_state.folders.outputs.foundation_folder_id
  default_region         = data.terraform_remote_state.data_ops_project.outputs.subnets_regions[0]
  environment            = module.constants.value.environment
  environment_folder_id  = data.terraform_remote_state.folders.outputs.environemnt_folder_id
  folder_id              = data.terraform_remote_state.folders.outputs.foundation_folder_id
  staging_project_id     = data.terraform_remote_state.data_ops_project.outputs.staging_project_id
  staging_project_number = data.terraform_remote_state.data_ops_project.outputs.staging_project_number
  staging_project_name   = data.terraform_remote_state.data_ops_project.outputs.staging_project_name
  staging_network_name   = data.terraform_remote_state.data_ops_project.outputs.network_name
  staging_subnetwork     = data.terraform_remote_state.data_ops_project.outputs.subnets_names[0]
  dataops_bucket         = data.terraform_remote_state.data_ops_project.outputs.csv_names_list
  ingress_buckets        = data.terraform_remote_state.ingress_project.outputs.bucket_names
  datalake_buckets       = data.terraform_remote_state.data_lake_project.outputs.research_to_bucket
  policy_for             = "project"

  enable_org_policy = false # Toggle switch to enable (true) or disable (false)

  airflow_config_overrides = try(data.terraform_remote_state.cloud-composer.outputs.gke_cluster, null)
  #access_control           = local.airflow_config_overrides == null ? "Admin" : "Public"
  access_control = "Admin"

  # Read the list of folders and create a dag per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]
}