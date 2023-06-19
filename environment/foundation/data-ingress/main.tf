#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../../foundation/constants"
}

#----------------------------------------------------------------------------
# SETUP LOCALS
#----------------------------------------------------------------------------

data "terraform_remote_state" "folders" {
  # Read the bucket name from tfstate
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

locals {
  function             = "data-ingress"
  org_id               = module.constants.value.org_id
  billing_account_id   = module.constants.value.billing_account_id
  environment          = module.constants.value.environment
  folder_id            = data.terraform_remote_state.folders.outputs.foundation_folder_id
  default_region       = module.constants.value.default_region
  log_retentation_days = 30

  # Read list of folders and create a bucket per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]
}

#----------------------------------------------------------------------------
# DATA INGRESS PROJECT MODULE
#----------------------------------------------------------------------------

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  // REQUIRED FIELDS
  name            = format("%v-sde-%v", local.environment[terraform.workspace], local.function)
  org_id          = local.org_id
  billing_account = local.billing_account_id
  folder_id       = local.folder_id

  // OPTIONAL FIELDS
  random_project_id           = true
  auto_create_network         = false
  activate_apis               = ["deploymentmanager.googleapis.com", "runtimeconfig.googleapis.com", "oslogin.googleapis.com", "compute.googleapis.com", "secretmanager.googleapis.com", "storage-api.googleapis.com", "servicemanagement.googleapis.com", "servicenetworking.googleapis.com", "cloudapis.googleapis.com", "iamcredentials.googleapis.com", "serviceusage.googleapis.com", "cloudasset.googleapis.com"]
  default_service_account     = "delete"
  disable_dependent_services  = true
  disable_services_on_destroy = true
  lien                        = false
  create_project_sa           = false
  labels = {
    environment = local.environment[terraform.workspace]
  }
}

#----------------------------------------------------------------------------
# VPC and FIREWALL MODULE
#----------------------------------------------------------------------------

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.project.project_id
  network_name = format("%v-%v-vpc", local.environment[terraform.workspace], local.function)
  routing_mode = "GLOBAL"
  description  = format("%s VPC for %s managed by Terraform.", local.environment[terraform.workspace], local.function)

  subnets = [
    {
      subnet_name               = format("%s-%s-%s", local.function, local.default_region, "subnet-01") # Changing will affect build
      subnet_ip                 = var.subnet_cidr
      subnet_region             = local.default_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
}
#----------------------------------------------------------------------------
# GCS Storage
#
# Additional buckets and folders can be created with this single module
#----------------------------------------------------------------------------

resource "random_id" "bucket_suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "researcher_dataset" {
  for_each                    = toset(local.research_wrkspc)
  name                        = "gcs-${lower(local.default_region)}-${lower(each.value)}-${random_id.bucket_suffix.hex}"
  location                    = local.default_region
  project                     = module.project.project_id
  uniform_bucket_level_access = true
}

resource "google_logging_project_bucket_config" "default" {
  # Increase the -Default logging bucket in days. Default is 30 days.
  # https://cloud.google.com/logging/docs/routing/overview
  project        = module.project.project_id
  location       = "global"
  retention_days = local.log_retentation_days
  bucket_id      = "_Default"
}

#----------------------------------------------------------------------------
# IAM
#----------------------------------------------------------------------------

module "project_iam_admins" {
  # Add an admins group at project level
  source = "../../../modules/iam/project_iam"

  for_each = toset(module.constants.value.ingress-project-admins)

  project_id            = module.project.project_id
  project_member        = each.value
  project_iam_role_list = var.project_iam_admin_roles
}

module "bucket_list_custom_role" {
  # Custom role with a single permission to list storage buckets
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.project.project_id
  project_iam_custom_role_description = "Custom Role for storage.buckets.list operation."
  project_iam_custom_role_title       = "[Custom] Storage Buckets List Role"
  project_iam_custom_role_id          = "sreCustomRoleStorageBucketsList"
  project_iam_custom_role_permissions = ["storage.buckets.list"]
  project_iam_custom_role_stage       = "GA"
}