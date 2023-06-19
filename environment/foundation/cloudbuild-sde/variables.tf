
variable "github_owner" {
  description = "GitHub Organization Name"
  type        = string
}

variable "github_repo_name" {
  description = "Name of GitHub Repo"
  type        = string
}

variable "plan_trigger_disabled" {
  description = "Whether the trigger is disabled or not. If true, the trigger will never result in a build."
  type        = bool
  default     = false
}

variable "branch_name" {
  description = "Regex matching branches to build. Exactly one a of branch name, tag, or commit SHA must be provided. The syntax of the regular expressions accepted is the syntax accepted by RE2 and described at https://github.com/google/re2/wiki/Syntax"
  type        = string
  default     = "^main$"
}

variable "iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined folder."
  type        = list(string)
  default = [
    "roles/bigquery.dataOwner",
    "roles/cloudbuild.builds.builder",
    "roles/composer.environmentAndStorageObjectAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/pubsub.admin",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageConsumer",
    "roles/storage.admin",
    "roles/resourcemanager.folderCreator"
  ]
}