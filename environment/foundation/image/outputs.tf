#----------------------------------------------------------------------------
# PROJECT FACTORY OUTPUTS
#----------------------------------------------------------------------------

output "project_id" {
  description = "Project Id"
  value       = module.image-project.project_id
}

output "project_name" {
  description = "Project Name"
  value       = module.image-project.project_name
}

output "project_number" {
  description = "Project Number"
  value       = module.image-project.project_number
}

output "image_build_email" {
  # tfdoc:output:consumers packer pipeline
  description = "Image build sa email"
  value       = google_service_account.image-builder.email
}

output "image_build_name" {
  # tfdoc:output:consumers packer pipeline
  description = "Image builder SA name"
  value       = google_service_account.image-builder.name
}

output "image_builder_vm" {
  # tfdoc:output:consumers packer pipeline
  description = "The name of the Packer builder VM"
  value       = local.image_builder_vm
}

#----------------------------------------------------------------------------
# VPC MODULE OUTPUTS
#----------------------------------------------------------------------------

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.image_vpc.network_name
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.image_vpc.subnets_names
}

output "subnets_regions" {
  description = "The region where the subnets will be created."
  value       = module.image_vpc.subnets_regions
}

#----------------------------------------------------------------------------
# CONTAINER ARTIFACT REGISTRY REPOSITORY OUTPUTS
#----------------------------------------------------------------------------

output "packer_container_artifact_repo_id" {
  description = "An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}."
  value       = local.toggle_packer ? module.packer_container_artifact_registry_repository.0.id : "not deployed"
}

output "packer_container_artifact_repo_name" {
  description = "The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1`"
  value       = local.toggle_packer ? module.packer_container_artifact_registry_repository.0.name : "not deployed"
}

output "dlp_container_artifact_repo_id" {
  description = "An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}."
  value       = local.toggle_dlp ? module.google_dlp_container.0.id : "not deployed"
}

output "dlp_container_artifact_repo_name" {
  description = "The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1`"
  value       = local.toggle_dlp ? module.google_dlp_container.0.name : "not deployed"
}

output "apt_repo_id" {
  description = "An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}."
  value       = local.toggle_apt ? module.google_apt_repo.0.id : "not deployed"
}

output "apt_repo_name" {
  # tfdoc:output:consumers workspace
  description = "The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1`"
  value       = local.toggle_apt ? module.google_apt_repo.0.name : "not deployed"
}

output "research_to_bucket" {
  # tfdoc:output:consumers workspace
  description = "Map of researcher name to their bucket name"
  value       = { for name, bucket in google_storage_bucket.bucket : name => bucket.name }
}