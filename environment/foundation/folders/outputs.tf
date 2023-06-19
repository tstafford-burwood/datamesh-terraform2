output "environemnt_folder_id" {
  # tfdoc:output:consumers data-ops-project
  value = google_folder.environment.id
}

output "foundation_folder_id" {
  # tfdoc:output:consumers data-lake data-ops-project image-project
  value = google_folder.environment.id
}

output "deployments_folder_id" {
  # tfdoc:output:consumers egress-project workspace-project data-lake cloud-composer-dags
  description = "The deployment folder id."
  #value       = google_folder.deployments_sde_parent.id
  value = google_folder.environment.id
}

output "ids" {
  description = "Folder ids."
  value = { for name, folder in google_folder.researcher_workspaces :
    name => folder.name
  }
}

output "names" {
  description = "Folder names."
  value = { for name, folder in google_folder.researcher_workspaces :
    name => folder.display_name
  }
}