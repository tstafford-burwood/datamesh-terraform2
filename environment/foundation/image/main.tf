#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

#----------------------------------------------------------------------------
# SETUP LOCALS
#----------------------------------------------------------------------------

data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

locals {
  function             = "image-factory"
  org_id               = module.constants.value.org_id
  billing_account_id   = module.constants.value.billing_account_id
  environment          = module.constants.value.environment
  folder_id            = data.terraform_remote_state.folders.outputs.foundation_folder_id
  cloudbuild_sa        = module.constants.value.cloudbuild_service_account
  image_default_region = module.constants.value.default_region
  image_builder_vm     = "image-builder-vm"

  # Read list of folders and create a bucket per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]

  # Artifact Registry Toggles
  toggle_packer = true
  toggle_dlp    = true
  toggle_apt    = true
}

#----------------------------------------------------------------------------
# IMAGE PROJECT MODULE
#----------------------------------------------------------------------------

module "image-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name                        = format("%v-sde-%v", local.environment[terraform.workspace], local.function)
  org_id                      = local.org_id
  billing_account             = local.billing_account_id
  folder_id                   = local.folder_id
  random_project_id           = true
  activate_apis               = ["cloudbuild.googleapis.com", "artifactregistry.googleapis.com", "deploymentmanager.googleapis.com", "runtimeconfig.googleapis.com", "oslogin.googleapis.com", "compute.googleapis.com", "secretmanager.googleapis.com", "storage-api.googleapis.com", "servicemanagement.googleapis.com", "cloudapis.googleapis.com", "serviceusage.googleapis.com", "cloudasset.googleapis.com"]
  default_service_account     = "delete"
  disable_dependent_services  = true
  disable_services_on_destroy = true
  lien                        = false
  create_project_sa           = false
  labels = {
    environment = local.environment[terraform.workspace]
  }
}

module "image_vpc" {
  # Note: the subnet name is used in the cloudbuild packer-bastion-image.yaml. 
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.image-project.project_id
  network_name = format("%v-%v-vpc", local.environment[terraform.workspace], local.function)
  routing_mode = "GLOBAL"
  description  = format("%s VPC for %s managed by Terraform.", local.environment[terraform.workspace], local.function)
  subnets = [
    {
      subnet_name               = format("%s-%s-%s", local.function, local.image_default_region, "subnet-01") # Changing will affect build
      subnet_ip                 = "10.1.0.0/24"
      subnet_region             = local.image_default_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
}

module "firewall" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  version      = "~> 5.0"
  project_id   = module.image-project.project_id
  network_name = module.image_vpc.network_name
  rules = [{
    name                    = "image-build-ingress-build-vm"
    description             = "Allow image builder vm ingress traffic"
    direction               = "INGRESS"
    priority                = 1000
    ranges                  = ["0.0.0.0/0"]
    source_tags             = ["image"]
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22", "5985", "5986"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}





#----------------------------------------------------------------------------
# ARTIFACT REGISTRY REPOSITORY
#----------------------------------------------------------------------------

module "packer_container_artifact_registry_repository" {
  count  = local.toggle_packer == true ? 1 : 0
  source = "../../../modules/artifact_registry"

  artifact_repository_project_id  = module.image-project.project_id
  artifact_repository_name        = "packer"
  artifact_repository_format      = "DOCKER"
  artifact_repository_location    = local.image_default_region
  artifact_repository_description = "Packer container Artifact Registry"
  artifact_repository_labels      = { "repository" : "packer-container" }
}

module "google_dlp_container" {
  count  = local.toggle_dlp == true ? 1 : 0
  source = "../../../modules/artifact_registry"

  artifact_repository_project_id  = module.image-project.project_id
  artifact_repository_name        = "google-dlp"
  artifact_repository_format      = "DOCKER"
  artifact_repository_location    = local.image_default_region
  artifact_repository_description = "Google DLP container - Terraform managed."
  artifact_repository_labels      = { "repository" : "dlp-container" }
}

module "google_apt_repo" {
  count  = local.toggle_apt == true ? 1 : 0
  source = "../../../modules/artifact_registry"

  artifact_repository_project_id  = module.image-project.project_id
  artifact_repository_name        = "apt-repo"
  artifact_repository_format      = "Apt"
  artifact_repository_location    = local.image_default_region
  artifact_repository_description = "Private Apt Repo - Terraform managed."
  artifact_repository_labels      = { "repository" : "apt-repo" }
}