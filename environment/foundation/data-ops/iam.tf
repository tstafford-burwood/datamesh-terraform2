module "project-iam-admins" {
  # Project level roles for admins  
  for_each = toset(local.data_ops_admins)

  source                = "../../../modules/iam/project_iam"
  project_id            = module.secure-staging-project.project_id
  project_member        = each.value
  project_iam_role_list = var.data_ops_admin_project_iam_roles
}

# module "project_iam_data_stewards" {
#   # Project level roles for data stewards
#   for_each = length(local.data_ops_stewards) > 0 ? toset(local.data_ops_stewards) : []

#   source                = "../../../modules/iam/project_iam"
#   project_id            = module.secure-staging-project.project_id
#   project_member        = each.value
#   project_iam_role_list = var.stewards_project_iam_roles
# }

module "staging_project_iam_custom_role" {
  # Custom role with a single permission to list storage buckets
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.secure-staging-project.project_id
  project_iam_custom_role_description = "Custom SDE Role for storage.buckets.list operation."
  project_iam_custom_role_title       = "[Custom] SDE Storage Buckets List Role"
  project_iam_custom_role_id          = "sreCustomRoleStorageBucketsList"
  project_iam_custom_role_permissions = ["storage.buckets.list"]
  project_iam_custom_role_stage       = "GA"
}

# resource "google_project_iam_member" "staging_project_custom_srde_role" {
#   # Loop through all stewards and assign custom role storage list permission to view buckets
#   for_each = length(local.data_ops_stewards) > 0 ? toset(local.data_ops_stewards) : []

#   project = module.secure-staging-project.project_id
#   role    = module.staging_project_iam_custom_role.name
#   member  = each.value
# }





resource "google_project_iam_member" "dlp_service_account_iam" {
  # Project level roles for the DLP Service Agent
  for_each = toset(var.dlp_service_agent_iam_role_list)

  project = module.secure-staging-project.project_id
  role    = each.value
  # The DLP Service Agent is created during the cloud build pipeline
  member = "serviceAccount:service-${module.secure-staging-project.project_number}@dlp-api.iam.gserviceaccount.com"
}

resource "google_artifact_registry_repository_iam_member" "repo_google_dlp" {
  # Grant the Google Cloud Run Service Agent Artifactory Read Permission to the Image Project
  # to pull and read the container image into Cloud Run  
  count = local.image_project_id != "" ? 1 : 0

  project    = local.image_project_id
  location   = local.default_region
  repository = "google-dlp"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${module.secure-staging-project.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
}