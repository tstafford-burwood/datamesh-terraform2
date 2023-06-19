resource "google_project_service" "apis" {
  # Enable APIs on the Cloud Build project
  for_each = toset(var.services)
  project  = var.project_id
  service  = each.value
}