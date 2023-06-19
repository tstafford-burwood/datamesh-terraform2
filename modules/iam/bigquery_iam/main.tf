resource "google_bigquery_dataset_iam_member" "additive" {
  # loop through all IAM roles
  for_each = toset(var.bq_iam_list)

  project    = var.project_id
  dataset_id = var.dataset_id
  role       = each.value
  member     = var.member
}