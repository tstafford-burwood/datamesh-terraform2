module "workspace_1" {
  source = "../../../modules/researcher_workspaces"

  // Globals
  billing_account            = local.billing_account_id
  environment                = local.environment
  org_id                     = local.org_id
  folder_id                  = local.srde_folder_id
  region                     = local.region
  wrkspc_folders             = local.wrkspc_folders
  cloudbuild_service_account = local.cloudbuild_service_account
  lbl_department             = var.lbl_department
  enforce                    = true
  force_destroy              = true
  set_disable_sa_create      = var.set_disable_sa_create
  set_vm_os_login            = var.set_vm_os_login
  researcher_workspace_name  = local.researcher_workspace_name

  // Data Ingress
  data_ingress_bucket_names   = local.data_ingress_bucket
  data_ingress_project_id     = local.data_ingress_id
  data_ingress_project_number = local.data_ingress

  // Data Ops
  data_ops_bucket         = local.data_ops_bucket
  data_ops_project_id     = local.staging_project_id
  data_ops_project_number = local.staging_project_number
  cloud_composer_email    = local.composer_sa
  composer_ariflow_uri    = local.composer_ariflow_uri
  composer_dag_bucket     = local.dag_bucket
  csv_names_list          = local.cordon_bucket
  golden_image_version    = var.golden_image_version
  research_to_bucket      = local.data_ops_bucket
  vpc_connector           = local.vpc_connector
  num_instances           = var.num_instances
  instance_name           = var.instance_name

  // Data Lake  
  data_lake_bucket_list_custom_role = local.data_lake_custom_role
  data_lake_project_id              = local.data_lake_id
  data_lake_project_number          = local.data_lake
  data_lake_research_to_bucket      = local.data_lake_bucket

  // Imaging
  imaging_bucket_name = local.imaging_bucket
  imaging_project_id  = local.imaging_project_id

  // IAM
  data_stewards      = var.data_stewards
  external_users_vpc = var.external_users_vpc
  project_admins     = var.project_admins
  researchers        = var.researchers

  // VPC Perimeter
  access_policy_id                 = local.parent_access_policy_id
  access_context_manager_policy_id = local.parent_access_policy_id
  serviceaccount_access_level_name = local.fdn_sa
  common_name                      = replace(local.researcher_workspace_name, "-", "_")
  additional_access_levels         = [local.fdn_sa, local.fdn_image]                                                                     # read from state the existing access levels
  members                          = distinct(flatten([var.data_stewards, var.external_users_vpc, var.project_admins, var.researchers])) # all members to the access level
  access_level_ip_subnetworks      = []
  restricted_services              = ["bigquery.googleapis.com", "storage.googleapis.com"]
  ingress_policies                 = []
  egress_policies = [{
    "from" = {
      "identity_type" = "ANY_SERVICE_ACCOUNT"
      "identities"    = []
    },
    "to" = {
      "resources" = ["*"]
      "operations" = {
        "artifactregistry.googleapis.com" = {
          "methods" = ["*"]
        },
        "storage.googleapis.com" = {
          "methods" = ["*"]
        },
      }
    }
  }, ]

  bridge1_resources = [local.staging_project_number, local.data_lake]
  bridge2_resources = [local.imaging_project_number]
}