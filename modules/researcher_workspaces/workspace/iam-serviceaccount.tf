# -------------------------------------------------------------------------------------
# WORKSPACE PERMISSIONS
# Create a service account called `notebook-sa` and grant it roles at the
# project level.
# -------------------------------------------------------------------------------------

resource "google_service_account" "notebook_sa" {
  # Create a service account
  account_id   = "notebook-sa"
  display_name = "Notebook Service Account"
  project      = module.workspace_project.project_id
  description  = "Terraform Managed"

  depends_on = [
    time_sleep.wait_60_seconds,
  ]
}

module "notebook_sa_iam" {
  # Project level roles for the service account
  source         = "../../iam/project_iam"
  project_id     = module.workspace_project.project_id
  project_member = "serviceAccount:${google_service_account.notebook_sa.email}"
  project_iam_role_list = [
    "roles/compute.osLogin",
    "roles/storage.admin",           # Grants full control over objects, including listing, creating, viewing, and deleting objects
    "roles/compute.instanceAdmin.v1" # Full control of Compute Engine instances
  ]
}

# -------------------------------------------------------------------------------------
# DATA LAKE PERMISSIONS
# Grant the `notebook-sa` service access to list the buckets
# in Data Lake, but only READ from its assigned research_workspace_name
# -------------------------------------------------------------------------------------

resource "google_project_iam_member" "notebook_sa" {
  # Add the notebook service account to custom role in data lake to list buckets
  project = local.data_lake_id
  role    = local.data_lake_custom_role
  member  = "serviceAccount:${google_service_account.notebook_sa.email}"
}

resource "google_storage_bucket_iam_binding" "notebook_sa" {
  # Add the notebook service account to the bucket in data lake bucket

  # The value coming in from the data-lake.tf is a map with the key being the researcher name and the value being a list of buckets (should be 1 bucket)
  # To get the bucket name, need to use the lookup function to find the bucket name and then use the
  # element to retrieve the single element from the list
  bucket  = lookup(local.data_lake_bucket, local.researcher_workspace_name, "") # retrieve the value of a single element from the map
  role    = "roles/storage.objectViewer"                                        # storage object viewer
  members = ["serviceAccount:${google_service_account.notebook_sa.email}"]
}

# -------------------------------------------------------------------------------------
# IMAGING PROJECT PERMISSIONS
# Allow the `notebook-sa` to pull data in from the Artifact Registry hosted in
# imaging factory.
# -------------------------------------------------------------------------------------

resource "google_project_iam_member" "notebook_sa_imaging_prj" {
  # Add the notebook service account as artifact registry viewer in imaging factory
  project = local.imaging_project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.notebook_sa.email}"
}

resource "google_artifact_registry_repository_iam_binding" "notebook_sa" {
  # Add the notebook service account to the Apt artifact repo 
  project    = local.imaging_project_id
  location   = var.region
  repository = local.apt_repo_name
  role       = "roles/artifactregistry.reader"
  members    = ["serviceAccount:${google_service_account.notebook_sa.email}"]
}