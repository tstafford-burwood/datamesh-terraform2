#----------------------------------------------------------------------------------------------
# WORKSAPCE - IAM MEMBER BINDING
#----------------------------------------------------------------------------------------------

module "project_iam_admins" {
  source = "../../iam/project_iam"

  for_each = toset(var.project_admins)

  project_id     = module.researcher-data-egress-project.project_id
  project_member = each.value
  project_iam_role_list = [
    "roles/viewer",
    "roles/storage.admin"
    #"roles/editor", # TEMP - BREAK GLASS
  ]
}

module "project_iam_external_users_vpc" {
  source = "../../iam/project_iam"

  for_each = toset(var.external_users_vpc)

  project_id     = module.researcher-data-egress-project.project_id
  project_member = each.value
  project_iam_role_list = [
    "roles/viewer",
    "roles/browser"
  ]
}

# module "project_iam_users" {
#   # The project users have permissions set at the project level. The roles allow
#   # these users to list the project (roles/browser) and list the buckets (custom role), but
#   # the access to a bucket is assigned at bucket level

#   source = "../../../../modules/iam/project_iam"

#   for_each = toset(var.project_users)

#   project_id     = module.researcher-data-egress-project.project_id
#   project_member = each.value
#   project_iam_role_list = [
#     "roles/viewer",
#   ]
# }

module "custom_role_storage_list" {
  # Create a custom role that only lists buckets witouth having to assing
  # primitive role/viewer
  source = "../../iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.researcher-data-egress-project.project_id
  project_iam_custom_role_description = "List only bucket - Terraform managed"
  project_iam_custom_role_id          = "customStorageViewer"
  project_iam_custom_role_title       = "Custom Storage Viewer"
  project_iam_custom_role_permissions = ["storage.buckets.list"]
}

# resource "google_project_iam_member" "staging_project_custom_srde_role" {
#   # Assign the custom role to the project users
#   for_each = toset(var.project_users)

#   project = module.researcher-data-egress-project.project_id
#   role    = module.custom_role_storage_list.name
#   member  = each.value
# }

module "composer_sa" {
  # Grant composer sa necessary storage iam roles
  source = "../../iam/project_iam"

  project_id     = module.researcher-data-egress-project.project_id
  project_member = "serviceAccount:${local.composer_sa}"
  project_iam_role_list = [
    "roles/browser",
    "roles/storage.objectAdmin",
  ]
}

resource "google_project_iam_member" "composer_sa" {
  # Assign the composer sa to custom role to list buckets
  project = module.researcher-data-egress-project.project_id
  role    = module.custom_role_storage_list.name
  member  = "serviceAccount:${local.composer_sa}"
}