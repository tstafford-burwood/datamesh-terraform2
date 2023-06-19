
# ------------------------------
# IAM
# ------------------------------

# The notebook-compute-sa provides the underlying policies that the compute uses to access other resources
# within the project for the data scientist.
#
# The data scientist should not be given the ability to become an SA.  Instead, they should be given
# OSLogin User role and SSH into the notebook
resource "google_service_account" "sa_p_notebook_compute" {
  project      = var.project
  account_id   = format("sa-p-notebook-compute-%s", random_string.random_name.result)
  display_name = "Notebooks in trusted environment"
}

resource "google_project_iam_member" "notebook_instance_compute" {
  project = var.project
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.sa_p_notebook_compute.email}"
}

resource "google_project_iam_member" "notebook_instance_bq_job" {
  project = var.project
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.sa_p_notebook_compute.email}"
}

resource "google_project_iam_member" "notebook_instance_bq_session" {
  project = var.project
  role    = "roles/bigquery.readSessionUser"
  member  = "serviceAccount:${google_service_account.sa_p_notebook_compute.email}"
}

resource "google_project_iam_member" "notebook_instance_caip" {
  project = var.project
  role    = "roles/notebooks.admin"
  member  = "serviceAccount:${google_service_account.sa_p_notebook_compute.email}"
}

# create custom role from dataViewer that doesn't allow export
module "role_restricted_data_viewer" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 6.4"

  target_level = "project"
  target_id    = var.project
  role_id      = format("blueprint_restricted_data_viewer_%s", random_string.random_name.result)
  title        = format("Blueprint restricted Data Viewer %s", random_string.random_name.result)
  description  = "BQ Data Viewer role with export removed"
  base_roles   = ["roles/bigquery.dataViewer"]
  permissions  = []
  excluded_permissions = [
    "bigquery.tables.export",
    "bigquery.models.export",
    "resourcemanager.projects.list",
  ]
  members = []
}

# IAM policy for each user (ie. data scientist)
resource "google_project_iam_member" "notebook_caip_user_iam" {
  project  = var.project
  role     = "roles/notebooks.viewer"
  for_each = toset(var.trusted_scientists)

  member = "user:${each.value}"
}

# IAM - add group binding for scientists.  the notebook's VM SA will already have access
# resource "google_bigquery_dataset_iam_binding" "iam_bq_confid_viewer" {
#   dataset_id = var.dataset_id
#   role       = format("projects/%s/roles/%s", var.project_trusted_data, module.role_restricted_data_viewer.custom_role_id)
#   project    = var.project_trusted_data

#   members = concat(var.confidential_groups, ["serviceAccount:${google_service_account.sa_p_notebook_compute.email}"])
# }

# resource "google_compute_instance_iam_member" "instance" {
#   # Option to grant each individual IAM rights to their instance
#   # Add the trusted scientist as compute admins of their instance
#   for_each = toset(var.trusted_scientists)

#   instance_name = resource.google_notebooks_instance.instance[each.value].name
#   project       = module.workspace_project.project_id
#   zone          = resource.google_notebooks_instance.instance[each.value].location
#   role          = "roles/compute.instanceAdmin"
#   member        = "user:${each.value}"

#   depends_on = [
#     resource.google_notebooks_instance.instance
#   ]
# }