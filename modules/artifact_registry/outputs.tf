#-------------------------------------
# ARTIFACT REGISTRY REPOSITORY OUTPUTS
#-------------------------------------

output "id" {
  description = "An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}."
  value       = google_artifact_registry_repository.repository.id
}

output "name" {
  description = "The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1`"
  value       = google_artifact_registry_repository.repository.name
}