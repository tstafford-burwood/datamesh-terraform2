output "parent_access_policy_id" {
  # tfdoc:output:consumers egress, workspaces
  description = "Access Policy ID"
  value       = var.parent_access_policy_id
}

output "serviceaccount_access_level_name" {
  # tfdoc:output:consumers egress, workspaces
  description = "Description of the Service account AccessLevel and its use. Does not affect behavior."
  value       = module.secure_data.name
  #value       = local.acclvl_sa
  #value       = module.access_level_service-accounts.name
}

output "image_prj_serviceaccount_access_level_name" {
  # tfoc:output:consumers egress, workspace
  description = "Name of the Access Level to access the imaging project perimeter"
  value       = module.secure_imaging.name
}

# output "foundation_perimeter_name" {
#   # tfdoc:output:consumers egress, workspaces
#   description = "The perimeter's name."
#   value       = module.foundation_perimeter_0.perimeter_name
# }

# output "foundation_resources" {
#   # tfdoc:output:consumers egress, workspaces
#   description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
#   value       = module.foundation_perimeter_0.resources
# }

# output "foundation_shared_resources" {
#   # tfdoc:output:consumers egress, workspaces
#   description = "A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources"
#   value       = module.foundation_perimeter_0.shared_resources
# }