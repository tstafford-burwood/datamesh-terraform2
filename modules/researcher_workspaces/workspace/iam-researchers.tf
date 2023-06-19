# -------------------------------------------------------------------------------------
# WORKSPACE PERMISSIONS
# Assign the list of researchers permissions at the project level to impersonate the
# service account and allowed to IAP into an instance in the workspace project.
# -------------------------------------------------------------------------------------

module "project_users" {
  # Project level roles for researchers
  for_each = toset(var.researchers)

  source         = "../../iam/project_iam"
  project_id     = module.workspace_project.project_id
  project_member = each.value
  project_iam_role_list = [
    "roles/serviceusage.serviceUsageConsumer", # Grant user the ability to use Services
    "roles/compute.viewer",                    # Allow researcher to view instance
    "roles/compute.osLogin",                   # Allow researcher to login
    "roles/browser",                           # Read access to browse hiearchy for the project
    "roles/iap.tunnelResourceAccessor",        # Access tunnel resources which use IAP
    "roles/notebooks.viewer",
    "roles/notebooks.admin"
  ]
}

resource "google_service_account_iam_member" "notebook" {
  # Grant each notebook user to act as the service account
  for_each = toset(var.researchers)

  service_account_id = google_service_account.notebook_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = each.value
}

resource "google_project_iam_member" "storage_custom_role" {
  # Loop through the list of researchers and grant them the custom storage list role.
  for_each = toset(concat(var.researchers))

  project = module.workspace_project.project_id
  role    = module.project_iam_custom_role.name
  member  = each.value
}

# -------------------------------------------------------------------------------------
# IMAGING PROJECT PERMISSIONS
# Allow the list of researchers to view the buckets in the imaging project to read
# the loginscript.bat
# -------------------------------------------------------------------------------------

resource "google_project_iam_member" "researcher" {
  # Add the researcher named account to the imaging project to browser to the project and bucket.
  for_each = toset(var.researchers)
  project  = local.imaging_project_id
  role     = "roles/viewer" # Grants access to view project
  member   = each.value
}

resource "google_storage_bucket_iam_binding" "researcher" {
  # Add the researcher named account to the bucket in the imaging bucket.
  # Granting the researcher named account will allow the researcher to see their bucket and download the login script.
  bucket  = lookup(local.imaging_bucket, local.researcher_workspace_name, "")
  role    = "roles/storage.objectViewer" # Grants access to view objects, excluding ACLs. Can list objects in a bucket
  members = var.researchers
}