#----------------------------------------------------------------------------
# DATA STEWARDS
# Data Stewards are not granted IAM roles to the researchers workspace.
# Instead, stewards are granted access to the projects in the SDE Foundation.
#----------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# DATA INGRESS
# Add stewards to the custom role to list the buckets in the data ingress
# project. Then grant the stewards access to just their research initiative.
# ---------------------------------------------------------------------------

resource "google_project_iam_member" "data_ingress_steward_browser" {
  # Loop through the list of stewards and grant them the custom storage list role.
  for_each = toset(concat(var.data_stewards))

  project = local.data_ingress_id
  role    = "roles/browser"
  member  = each.value
}

resource "google_project_iam_member" "data_ingress_steward" {
  # Loop through the list of stewards and grant them the custom storage list role.
  for_each = toset(concat(var.data_stewards))

  project = local.data_ingress_id
  role    = "projects/${local.data_ingress}/roles/sreCustomRoleStorageBucketsList"
  member  = each.value
}

resource "google_storage_bucket_iam_binding" "data_ingress_steward" {
  # Add the data steward named account to the bucket in the data ingress project
  count = length(var.data_stewards) > 0 ? 1 : 0

  bucket  = lookup(local.data_ingress_bucket, local.researcher_workspace_name, "")
  role    = "roles/storage.objectAdmin" # Grants access to view objects, excluding ACLs. Can list objects in a bucket
  members = var.data_stewards
}

# ---------------------------------------------------------------------------
# DATA OPS
# Add stewards to the data ops project and only allow them to see their
# research initiative buckets.
# ---------------------------------------------------------------------------

module "project_iam_data_stewards" {
  # Project level roles for data stewards
  for_each = length(var.data_stewards) > 0 ? toset(var.data_stewards) : []

  source                = "../../iam/project_iam"
  project_id            = local.staging_project_id
  project_member        = each.value
  project_iam_role_list = var.stewards_project_iam_roles
}

resource "google_storage_bucket_iam_binding" "data_ops_steward" {
  # Add the data steward named account to the bucket in the data ops project
  count = length(var.data_stewards) > 0 ? 1 : 0

  bucket  = lookup(local.data_ops_bucket, local.researcher_workspace_name, "")
  role    = "roles/storage.objectAdmin" # Grants access to view objects, excluding ACLs. Can list objects in a bucket
  members = var.data_stewards
}

resource "google_project_iam_member" "data_ops_steward" {
  # Loop through the list of stewards and grant them the custom storage list role.
  for_each = toset(concat(var.data_stewards))

  project = local.staging_project_id
  role    = "projects/${local.staging_project_id}/roles/sreCustomRoleStorageBucketsList"
  member  = each.value
}

# ---------------------------------------------------------------------------
# DATA lALKE
# Add stewards to the data lake project and only allow them to see their
# research initiative buckets.
# ---------------------------------------------------------------------------

resource "google_storage_bucket_iam_binding" "data_lake_steward" {
  # Add the data steward named account to the bucket in the data ingress project
  count = length(var.data_stewards) > 0 ? 1 : 0

  bucket  = lookup(local.data_lake_bucket, local.researcher_workspace_name, "")
  role    = "roles/storage.objectAdmin" # Grants access to view objects, excluding ACLs. Can list objects in a bucket
  members = var.data_stewards
}

resource "google_project_iam_member" "data_lake_steward_storage" {
  # Loop through the list of stewards and grant them the custom storage list role.
  for_each = toset(concat(var.data_stewards))

  project = local.data_lake_id
  role    = "projects/${local.data_lake_id}/roles/sreCustomRoleStorageBucketsList"
  member  = each.value
}

resource "google_project_iam_member" "data_lake_steward_browser" {
  # Loop through the list of stewards and grant them the custom storage list role.
  for_each = toset(concat(var.data_stewards))

  project = local.data_lake_id
  role    = "roles/browser"
  member  = each.value
}