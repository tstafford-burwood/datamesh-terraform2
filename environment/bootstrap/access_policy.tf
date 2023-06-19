# NOTE
# As of 3/7/23 could not scope a VPC SC down to a folder because the Google SDK requires this to be set from a service account vs a user account.
/*
1. The manual steps are to go to Google Console
2. Go to Security > VPC-SC (make sure you're at the Org level and not at project or folder level)
3. Select Manage Policies > + Create
4. Name the policy, assign at the desired folder level, and grant user and Cloud Build SA
5. Record the policy id and add to the foundation/vpc-sc/env/terraform.tfvars file
*/

# resource "google_access_context_manager_access_policy" "default" {
#   count  = var.access_policy_create != null ? 1 : 0
#   parent = "organizations/${var.org_id}"
#   title  = "Scoped Access Policy"
#   scopes = [google_folder.parent.id]
# }

# resource "google_access_context_manager_access_policy_iam_member" "default" {
#     count  = var.access_policy_create != null ? 1 : 0
#   name = google_access_context_manager_access_policy.default[count.index].name
#   role = "roles/accesscontextmanager.policyAdmin"
#   member = "group:sde-centralit@prorelativity.com"
# }

# variable "access_policy_create" {
#   description = "Access Policy configuration, fill in to create. Parent is in 'organizations/123456' format, scopes are in 'folders/456789' or 'projects/project_id' format."
#   type        = bool
#   default     = true
# }