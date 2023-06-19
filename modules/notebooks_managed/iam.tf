resource "google_project_iam_member" "notebook" {
  # IAM policy for each user (ie. data scientist)
  #for_each = toset(split("\n", replace(join("\n", tolist(var.trusted_scientists)), "/\\S+:/", "")))
  for_each = toset(local.format)

  project = var.project
  role    = var.role
  member  = "${local.member}:${each.value}"
}