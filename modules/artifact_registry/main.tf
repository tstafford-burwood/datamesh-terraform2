#-----------------------------
# ARTIFACT REGISTRY REPOSITORY
#-----------------------------

resource "google_artifact_registry_repository" "repository" {
  provider = google-beta

  project       = var.artifact_repository_project_id
  repository_id = var.artifact_repository_name
  format        = var.artifact_repository_format
  location      = var.artifact_repository_location
  description   = var.artifact_repository_description
  labels        = var.artifact_repository_labels
}