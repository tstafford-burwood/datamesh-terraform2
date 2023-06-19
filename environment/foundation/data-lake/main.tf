#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

#----------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
#----------------------------------------------------------------------------

data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

data "terraform_remote_state" "staging_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ops"
  }
}

#----------------------------------------------------------------------------
# SET LOCALS VALUES
#----------------------------------------------------------------------------

locals {
  function             = "data-lake"
  org_id               = module.constants.value.org_id
  billing_account_id   = module.constants.value.billing_account_id
  environment          = module.constants.value.environment
  folder_id            = data.terraform_remote_state.folders.outputs.foundation_folder_id
  default_region       = module.constants.value.default_region
  log_retentation_days = 30

  # Read from tfstate the data ops parameters  
  staging_project_id         = data.terraform_remote_state.staging_project.outputs.staging_project_id
  staging_project_number     = data.terraform_remote_state.staging_project.outputs.staging_project_number
  composer_sa                = try(data.terraform_remote_state.staging_project.outputs.email, "")
  notebook_sa                = try(data.terraform_remote_state.staging_project.outputs.notebook_sa_email, "")
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account

  # Read list of folders and create a bucket per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]
}

# ---------------------------------------------------------------------------
# DATA LAKE PROJECT
# ---------------------------------------------------------------------------

module "data-lake-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name                        = format("%v-sde-%v", local.environment[terraform.workspace], local.function)
  org_id                      = local.org_id
  billing_account             = local.billing_account_id
  folder_id                   = local.folder_id
  random_project_id           = true
  activate_apis               = ["compute.googleapis.com", "serviceusage.googleapis.com", "bigquery.googleapis.com", "healthcare.googleapis.com", "serviceusage.googleapis.com", "cloudasset.googleapis.com"]
  default_service_account     = "delete"
  disable_dependent_services  = true
  disable_services_on_destroy = true
  create_project_sa           = false
  labels = {
    environment = local.environment[terraform.workspace]
  }
}

resource "google_logging_project_bucket_config" "default" {
  # Increase the -Default logging bucket in days. Default is 30 days.
  # https://cloud.google.com/logging/docs/routing/overview
  project        = module.data-lake-project.project_id
  location       = "global"
  retention_days = local.log_retentation_days
  bucket_id      = "_Default"
}