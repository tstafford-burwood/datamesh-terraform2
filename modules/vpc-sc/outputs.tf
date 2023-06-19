output "name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
  value       = module.access_level_members.name
}

output "name_id" {
  description = "The fully-qualified name of the Access Level. Format: accessPolicies/{policy_id}/accessLevels/{name}"
  value       = module.access_level_members.name_id
}