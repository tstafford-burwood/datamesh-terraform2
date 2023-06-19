#--------------------------
# PROJECT IAM MEMBER MODULE
#--------------------------

resource "google_project_iam_member" "project" {

  for_each = toset(var.project_iam_role_list)

  project = var.project_id
  role    = each.value
  member  = var.project_member
}