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

data "terraform_remote_state" "image" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/image"
  }
}

data "google_storage_project_service_account" "gcs_account" {
  # DATA BLOCK TO RETRIEVE PROJECT'S GCS SERVICE ACCOUNT
  project = module.secure-staging-project.project_id
}

locals {
  function              = "data-ops"
  org_id                = module.constants.value.org_id
  billing_account_id    = module.constants.value.billing_account_id
  environment           = module.constants.value.environment
  environment_folder_id = data.terraform_remote_state.folders.outputs.environemnt_folder_id
  folder_id             = data.terraform_remote_state.folders.outputs.foundation_folder_id
  default_region        = module.constants.value.default_region
  log_retentation_days  = 30

  # Read from tfstate the image project parameters
  image_project_id     = data.terraform_remote_state.image.outputs.project_id
  image_project_number = data.terraform_remote_state.image.outputs.project_number

  # Read from constants.tf the groups/users
  data_ops_admins = module.constants.value.data-ops-admins
  #data_ops_stewards = module.constants.value.data-ops-stewards

  # Toggle VPC Serverless Connector - Used by Cloud Functions
  toggle_vpc_connector = true

  # Read list of folders and create a bucket per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]

}

module "secure-staging-project" {
  # Create the project
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name                        = format("%v-sde-%v", local.environment[terraform.workspace], local.function)
  org_id                      = local.org_id
  billing_account             = local.billing_account_id
  folder_id                   = local.folder_id
  random_project_id           = true
  activate_apis               = ["compute.googleapis.com", "pubsub.googleapis.com", "bigquery.googleapis.com", "composer.googleapis.com", "dlp.googleapis.com", "healthcare.googleapis.com", "notebooks.googleapis.com", "servicenetworking.googleapis.com", "dns.googleapis.com", "healthcare.googleapis.com", "run.googleapis.com", "datacatalog.googleapis.com", "serviceusage.googleapis.com", "cloudfunctions.googleapis.com", "vpcaccess.googleapis.com", "integrations.googleapis.com", "runapps.googleapis.com", "connectors.googleapis.com", "cloudkms.googleapis.com", "cloudasset.googleapis.com"]
  default_service_account     = "delete"
  disable_dependent_services  = true
  disable_services_on_destroy = true
  create_project_sa           = false
  labels = {
    environment = local.environment[terraform.workspace]
  }
}

module "vpc" {
  # Create the VPC
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0"

  project_id   = module.secure-staging-project.project_id
  network_name = format("%v-%v-vpc", local.environment[terraform.workspace], local.function)
  routing_mode = "GLOBAL"
  description  = format("%s VPC for %s managed by Terraform.", local.environment[terraform.workspace], local.function)
  subnets = [
    {
      subnet_name               = format("%s-%s-%s", local.function, local.default_region, "subnet-01")
      subnet_ip                 = "10.0.0.0/16"
      subnet_region             = local.default_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]

  secondary_ranges = {
    format("%s-%s-%s", local.function, local.default_region, "subnet-01") = [
      {
        range_name    = "kubernetes-pods"
        ip_cidr_range = "10.168.0.0/17"
      },
      {
        range_name    = "kubernetes-services"
        ip_cidr_range = "10.168.128.0/22"
      }
    ]
  }
}

resource "google_vpc_access_connector" "connector" {
  count          = local.toggle_vpc_connector == true ? 1 : 0
  name           = "cloud-function"
  project        = module.secure-staging-project.project_id
  region         = local.default_region
  network        = module.vpc.network_id
  machine_type   = "e2-micro"
  min_instances  = 2
  max_instances  = 4
  min_throughput = 200
  max_throughput = 400
  ip_cidr_range  = "10.132.0.0/28"
}

resource "google_logging_project_bucket_config" "default" {
  # Increase the -Default logging bucket in days. Default is 30 days.
  # https://cloud.google.com/logging/docs/routing/overview
  project        = module.secure-staging-project.project_id
  location       = "global"
  retention_days = local.log_retentation_days
  bucket_id      = "_Default"
}