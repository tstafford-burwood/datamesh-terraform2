#--------------------------------
# PROJECT IAM CUSTOM ROLE OUTPUTS
#--------------------------------

output "name" {
  description = "The name of the role in the format projects/{{project}}/roles/{{role_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings."
  value       = google_project_iam_custom_role.project_iam_custom_role.name
}

output "role_id" {
  description = "The role_id name."
  value       = google_project_iam_custom_role.project_iam_custom_role.role_id
}