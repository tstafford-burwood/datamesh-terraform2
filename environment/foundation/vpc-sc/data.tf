#------------------------------------------------------------------------
# IMPORT CONSTANTS
#------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

#------------------------------------------------------------------------
# RETRIEVE TF STATE
#------------------------------------------------------------------------

data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

data "terraform_remote_state" "cloud_composer_sa" {
  # Get the Cloud Composer Service Account from TFSTATE
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/cloud-composer"
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

data "terraform_remote_state" "data_ingress" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ingress"
  }
}

data "terraform_remote_state" "image_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/image"
  }
}

data "terraform_remote_state" "datalake_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-lake"
  }
}

data "terraform_remote_state" "workspace_project" {
  # Loop through the researcher projects
  for_each  = toset(local.research_wrkspc)
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "deployments/${terraform.workspace}/researcher-projects/${each.value}"
  }
}

#------------------------------------------------------------------------
# SET LOCAL VALUES
#------------------------------------------------------------------------

locals {
  environment                = module.constants.value.environment
  parent_access_policy_id    = var.parent_access_policy_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  composer_sa                = try(data.terraform_remote_state.cloud_composer_sa.outputs.email, "")
  image_project              = try(data.terraform_remote_state.image_project.outputs.project_number, "")
  image_project_sa           = try(data.terraform_remote_state.image_project.outputs.image_build_email, "")
  data_ingress               = try(data.terraform_remote_state.data_ingress.outputs.project_number, "")
  data_ops                   = try(data.terraform_remote_state.staging_project.outputs.staging_project_number, "")
  data_lake                  = try(data.terraform_remote_state.datalake_project.outputs.data_lake_project_number, "")

  # Need to add the service accounts from the researcher workspaces. To do this we need to find the path of the tfstate,
  # read the service accounts from the state, and add them to the access context manager.

  # Build a list of service accounts in the `foundation` projects to be added to the access context manager
  fnd_list = ["serviceAccount:${local.cloudbuild_service_account}",
    "serviceAccount:${local.composer_sa}",
    "serviceAccount:service-${local.data_ops}@compute-system.iam.gserviceaccount.com",
    "serviceAccount:${local.data_ops}@cloudbuild.gserviceaccount.com",
    "serviceAccount:service-${local.data_ops}@gcf-admin-robot.iam.gserviceaccount.com",
    "serviceAccount:${local.image_project_sa}",
  ]

  # Read from state the researcher folder names
  wrkspc_folders = data.terraform_remote_state.folders.outputs.ids

  # Build a list of the researcher projects names from the folder list
  research_wrkspc = [for k, v in local.wrkspc_folders : k]

  # Build a list of notebooks SAs from research workspaces
  # Create a list by looping through the different researcher projects and checking if the output is successful
  nb_sas = [for k in data.terraform_remote_state.workspace_project : k.outputs.notebook_sa_member if can(k.outputs.notebook_sa_member)]

  # Create a list of stewards looping through the different research projects
  stewards_wrkspc = flatten([for stewards in data.terraform_remote_state.workspace_project : stewards.outputs.data_stewards if can(stewards.outputs.data_stewards)])

  # Contact the two lists of foundation service accounts and researcher workspaces
  # Things like the composer-sa and the workspace notebook-sa
  acclvl_sa       = concat(local.fnd_list, local.nb_sas)
  acclvl_stewards = concat(local.stewards_wrkspc)
}