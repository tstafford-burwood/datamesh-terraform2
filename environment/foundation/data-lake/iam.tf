module "project-iam-admins" {
  # Assign Data Lake project admins group and roles
  source = "../../../modules/iam/project_iam"

  for_each = toset(module.constants.value.data-lake-admins)

  project_id            = module.data-lake-project.project_id
  project_member        = each.value
  project_iam_role_list = var.project_iam_admins_list
}

module "project_iam_data_stewards" {
  # Project level roles for data stewards
  source = "../../../modules/iam/project_iam"

  for_each = toset(module.constants.value.data-lake-viewers)

  project_id            = module.data-lake-project.project_id
  project_member        = each.value
  project_iam_role_list = var.stewards_project_iam_roles
}

module "bucket_list_custom_role" {
  # Custom role with a single permission to list storage buckets
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.data-lake-project.project_id
  project_iam_custom_role_description = "Custom Role for storage.buckets.list operation."
  project_iam_custom_role_title       = "[Custom] Storage Buckets List Role"
  project_iam_custom_role_id          = "sreCustomRoleStorageBucketsList"
  project_iam_custom_role_permissions = ["storage.buckets.list"]
  project_iam_custom_role_stage       = "GA"
}