# ---------------------------------------------------------------------------
# PROJECT ADMINS
# Project admins are accounts that can administer the VM instance, help
# customize it, and configure it.
# ---------------------------------------------------------------------------

module "project_admins" {
  # Project level roles for admins
  for_each = toset(var.project_admins)

  source         = "../../iam/project_iam"
  project_id     = module.workspace_project.project_id
  project_member = each.value
  project_iam_role_list = [
    "roles/compute.osLogin",
    "roles/iam.serviceAccountUser",
    "roles/iap.tunnelResourceAccessor",
    "roles/storage.admin",
    "roles/compute.instanceAdmin.v1"
    # "roles/editor" # TEMP - BREAK GLASS
  ]
}

module "project_iam_custom_role" {
  # The researchers need to list the storage buckets, but instead of granting each user
  # the primitive role `Viewer` at the project, create a custom role with a single permission to list storage buckets
  source = "../../iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.workspace_project.project_id
  project_iam_custom_role_description = "Custom Role for storage.buckets.list operation."
  project_iam_custom_role_title       = "[Custom] Storage Buckets List Role"
  project_iam_custom_role_id          = "CustomRoleStorageBucketsList"
  project_iam_custom_role_permissions = ["storage.buckets.list"]
  project_iam_custom_role_stage       = "GA"
}
