module "egress_project" {
  source = "./egress"

  environment               = var.environment
  billing_account           = var.billing_account
  org_id                    = var.org_id
  folder_id                 = var.folder_id
  researcher_workspace_name = var.researcher_workspace_name
  region                    = var.region
  data_ops_project_id       = var.data_ops_project_id
  data_ops_project_number   = var.data_ops_project_number
  vpc_connector             = var.vpc_connector
  data_ops_bucket           = var.data_ops_bucket
  cloud_composer_email      = var.cloud_composer_email
  composer_ariflow_uri      = var.composer_ariflow_uri
  composer_dag_bucket       = var.composer_dag_bucket
  prefix                    = var.prefix
  wrkspc_folders            = var.wrkspc_folders
  enforce                   = var.enforce
  project_admins            = var.project_admins
  data_stewards             = var.data_stewards
  external_users_vpc        = var.external_users_vpc
  lbl_department            = var.lbl_department
}

module "workspace_project" {
  source = "./workspace"

  environment                       = var.environment
  billing_account                   = var.billing_account
  org_id                            = var.org_id
  folder_id                         = var.folder_id
  researcher_workspace_name         = var.researcher_workspace_name
  region                            = var.region
  cloudbuild_service_account        = var.cloudbuild_service_account
  research_to_bucket                = var.research_to_bucket
  csv_names_list                    = var.csv_names_list
  imaging_project_id                = var.imaging_project_id
  apt_repo_name                     = var.apt_repo_name
  egress_project_number             = module.egress_project.project_id
  data_ingress_project_id           = var.data_ingress_project_id
  data_ingress_project_number       = var.data_ingress_project_number
  data_ingress_bucket_names         = var.data_ingress_bucket_names
  imaging_bucket_name               = var.imaging_bucket_name
  data_lake_project_id              = var.data_lake_project_id
  data_lake_project_number          = var.data_lake_project_number
  data_lake_research_to_bucket      = var.data_lake_research_to_bucket
  access_policy_id                  = var.access_policy_id
  serviceaccount_access_level_name  = var.serviceaccount_access_level_name
  notebook_sa_email                 = var.notebook_sa_email
  data_ops_project_id               = var.data_ops_project_id
  data_ops_project_number           = var.data_ops_project_number
  composer_dag_bucket               = var.composer_dag_bucket
  project_admins                    = var.project_admins
  instance_name                     = var.instance_name
  researchers                       = var.researchers
  data_stewards                     = var.data_stewards
  lbl_department                    = var.lbl_department
  data_lake_bucket_list_custom_role = var.data_lake_bucket_list_custom_role
  set_vm_os_login                   = var.set_vm_os_login
  set_disable_sa_create             = var.set_disable_sa_create
  num_instances                     = var.num_instances
  golden_image_version              = var.golden_image_version

  depends_on = [
    module.egress_project
  ]
}

locals {
  suffix             = var.common_suffix != "" ? var.common_suffix : random_id.suffix.hex
  access_policy_name = "ac_wrkspc_${var.common_name}_${local.suffix}"
  perimeter_name     = "rp_wrkspc_${var.common_name}_${local.suffix}"
  bridge_name        = ""
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 5.0"

  policy      = var.access_context_manager_policy_id
  name        = local.access_policy_name
  description = var.access_level_description

  members = var.members

  ip_subnetworks = var.access_level_ip_subnetworks
  regions        = var.access_level_regions

  depends_on = [
    module.egress_project,
    module.workspace_project
  ]
}

module "service_perimeter" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 5.0"

  policy         = var.access_context_manager_policy_id
  perimeter_name = local.perimeter_name
  description    = var.perimeter_description

  resources = [
    module.egress_project.project_number,
    module.workspace_project.project_number,
  ]

  resource_keys = ["egress", "workspace"]

  #restricted_services = var.restricted_services
  restricted_services = [
    "storage.googleapis.com",
    "run.googleapis.com",
    "bigquery.googleapis.com",
    "bigtable.googleapis.com",
    "cloudbuild.googleapis.com",
    "aiplatform.googleapis.com",
    "sqladmin.googleapis.com",
    "pubsub.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
  vpc_accessible_services = [
    "notebooks.googleapis.com",
    "compute.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]

  access_levels    = flatten([var.additional_access_levels, [module.access_level_members.name]])
  ingress_policies = var.ingress_policies
  egress_policies  = var.egress_policies

  depends_on = [
    module.egress_project,
    module.workspace_project,
  ]
}

module "bridge_vpc_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"
  version = "~> 5.0"

  policy         = var.access_context_manager_policy_id
  perimeter_name = format("bridge_foundation_%s", lower(replace(var.researcher_workspace_name, "-", "")))
  description    = "Research bridge to Foundation. Terraform managed"

  resources     = flatten([[module.workspace_project.project_number], var.bridge1_resources])
  resource_keys = ["one", "two"]

  depends_on = [
    module.egress_project,
    module.workspace_project,
    module.access_level_members,
    module.service_perimeter
  ]
}

module "bridge_vpc_perimeter_2" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"
  version = "~> 5.0"

  policy         = var.access_context_manager_policy_id
  perimeter_name = format("bridge_image_prj_%s", lower(replace(var.researcher_workspace_name, "-", "")))
  description    = "Research bridge to Imaging Project. Terraform managed"

  resources     = flatten([[module.workspace_project.project_number, module.egress_project.project_number], var.bridge2_resources])
  resource_keys = ["one", "two"]

  depends_on = [
    module.egress_project,
    module.workspace_project,
    module.access_level_members,
    module.service_perimeter
  ]
}