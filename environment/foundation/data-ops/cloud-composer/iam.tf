#----------------------------------------------------------------------------
# SERVICE ACCOUNTS
#----------------------------------------------------------------------------

resource "google_service_account" "composer_sa" {
  # Create a custom service account used by Cloud Composer
  account_id   = substr("${local.environment[terraform.workspace]}-composer-sa", 0, 28)
  display_name = "Cloud Composer SA"
  description  = "Terraform managed"
  project      = local.staging_project_id

  depends_on = [
    time_sleep.wait_120_seconds
  ]
}

resource "google_project_iam_member" "custom_service_account" {
  # Bind Composer SA to some roles at the project level
  provider = google-beta
  project  = local.staging_project_id
  member   = format("serviceAccount:%s", google_service_account.composer_sa.email)
  // Role for Public IP environments
  role = "roles/composer.worker"
}

# resource "google_service_account_iam_member" "custom_service_account" {
#   # Add a new role binding to your environments service account
#   provider           = google-beta
#   service_account_id = google_service_account.custom_service_account.name
#   role               = "roles/composer.ServiceAgentV2Ext"
#   member             = "serviceAccount:service-${local.staging_project_number}@cloudcomposer-accounts.iam.gserviceaccount.com"
# }

#----------------------------------------------------------------------------
# SERVICE ACCOUNT IAM ROLES
#----------------------------------------------------------------------------

module "folder_iam_member" {
  # Assign the Cloud Composer Service Account at the folder level so it can move data between projects.
  source        = "../../../../modules/iam/folder_iam"
  folder_id     = local.environment_folder_id
  iam_role_list = var.composer_iam_roles
  folder_member = format("serviceAccount:%s", google_service_account.composer_sa.email)
}