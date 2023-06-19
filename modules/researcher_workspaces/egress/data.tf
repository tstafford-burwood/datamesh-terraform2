#----------------------------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------------------------

# module "constants" {
#   source = "../../../foundation/constants"
# }

#----------------------------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
# Retrieve Terraform state
#----------------------------------------------------------------------------------------------

# data "terraform_remote_state" "image_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = var.tf_state_bucket
#     prefix = "foundation/${terraform.workspace}/image"
#   }
# }

# data "terraform_remote_state" "staging_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = var.tf_state_bucket
#     prefix = "foundation/${terraform.workspace}/data-ops"
#   }
# }

# data "terraform_remote_state" "cloud_composer" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = var.tf_state_bucket
#     prefix = "foundation/${terraform.workspace}/cloud-composer"
#   }
# }

# data "terraform_remote_state" "folders" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = var.tf_state_bucket
#     prefix = "foundation/${terraform.workspace}/folders"
#   }
# }

locals {
  environment               = var.environment
  org_id                    = var.org_id
  billing_account_id        = var.billing_account
  researcher_workspace_name = lower(var.researcher_workspace_name)
  srde_folder_id            = var.folder_id
  staging_project_id        = var.data_ops_project_id
  staging_project_number    = var.data_ops_project_number
  vpc_connector             = var.vpc_connector
  pubsub_appint_results     = var.pubsub_appint_results
  data_ops_bucket           = var.data_ops_bucket
  composer_sa               = var.cloud_composer_email
  composer_ariflow_uri      = var.composer_ariflow_uri
  dag_bucket                = var.composer_dag_bucket
  policy_for                = "project"
  composer_version          = "composer-2.1.8-airflow-2.4.3"

  # Read the list of folders and create a dag per researcher initiative
  wrkspc_folders  = var.wrkspc_folders
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]
}