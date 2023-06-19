#--------------------------
# FOLDER IAM MEMBER MODULE
#--------------------------

resource "google_folder_iam_member" "folder" {

  for_each = toset(var.iam_role_list)

  folder = var.folder_id
  role   = each.value
  member = var.folder_member
}