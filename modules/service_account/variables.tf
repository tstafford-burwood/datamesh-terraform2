#--------------------------
# SERVICE ACCOUNT VARIABLES
#--------------------------

// REQUIRED VARIABLES

variable "project_id" {
  description = "The project ID to associate the service account to"
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "billing_account_id" {
  description = "The ID of the billing account to associate this project with"
  type        = string
  default     = ""
}

variable "description" {
  type        = string
  description = "Descriptions of the created service accounts (defaults to no description)"
  default     = ""
}

variable "display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "generate_keys" {
  description = "Generate keys for service accounts."
  type        = bool
  default     = false
}

variable "grant_billing_role" {
  description = "Grant billing user role."
  type        = bool
  default     = false
}

variable "grant_xpn_roles" {
  description = "Grant roles for shared VPC management."
  type        = bool
  default     = false
}

variable "service_account_names" {
  description = "Names of the service accounts to create."
  type        = list(string)
  default     = [""]
}

variable "org_id" {
  description = "The organization ID."
  type        = string
  default     = ""
}

variable "prefix" {
  description = "Prefix applied to service account names."
  type        = string
  default     = ""
}

variable "project_roles" {
  description = "Common roles to apply to all service accounts, project=>role as elements."
  type        = list(string)
  default     = []
}