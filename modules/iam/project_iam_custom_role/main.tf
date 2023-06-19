#-------------------------------
# PROJECT IAM CUSTOM ROLE MODULE
#-------------------------------

resource "google_project_iam_custom_role" "project_iam_custom_role" {
  project     = var.project_iam_custom_role_project_id
  description = var.project_iam_custom_role_description
  role_id     = var.project_iam_custom_role_id
  title       = var.project_iam_custom_role_title
  permissions = var.project_iam_custom_role_permissions
  stage       = var.project_iam_custom_role_stage
}