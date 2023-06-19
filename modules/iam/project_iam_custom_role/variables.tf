#----------------------------------
# PROJECT IAM CUSTOM ROLE VARIABLES
#----------------------------------

variable "project_iam_custom_role_project_id" {
  description = "The project that the custom role will be created in. Defaults to the provider project configuration."
  type        = string
  default     = ""
}

variable "project_iam_custom_role_description" {
  description = "A human-readable description for the role."
  type        = string
  default     = "Custom role created with Terraform."
}

variable "project_iam_custom_role_id" {
  description = "The camel case role id to use for this role. Cannot contain - characters."
  type        = string
  default     = ""
}

variable "project_iam_custom_role_title" {
  description = "A human-readable title for the role."
  type        = string
  default     = ""
}

variable "project_iam_custom_role_permissions" {
  description = "The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified."
  type        = list(string)
  default     = []
}

variable "project_iam_custom_role_stage" {
  description = "The current launch stage of the role. Defaults to GA. List of possible stages is [here](https://cloud.google.com/iam/docs/reference/rest/v1/organizations.roles#Role.RoleLaunchStage)."
  type        = string
  default     = "GA"
}