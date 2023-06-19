variable "environment" {}

variable "billing_account" {
  description = "Google Billing Account ID"
  type        = string
}

variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "folder_id" {
  description = "Folder ID to host project"
  type        = string
}

variable "researcher_workspace_name" {
  description = "Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist."
  type        = string
  default     = "workspace-1"
}

variable "region" {
  description = "The default region to place resources."
  type        = string
  default     = "us-central1"
}

variable "data_ops_project_id" {
  description = "Project ID for data ops project"
  type        = string
}

variable "data_ops_project_number" {
  description = "Project number for data ops project"
  type        = string
}

variable "vpc_connector" {
  description = "The VPC Connector ID"
  type        = string
}

variable "pubsub_appint_results" {
  description = "The name of the Pub/Sub for Application Insights results"
  type        = string
  default     = "application-integration-trigger-results"
}

variable "data_ops_bucket" {}


variable "cloud_composer_email" {
  type = string
}

variable "composer_ariflow_uri" {
  type = string
}

variable "composer_dag_bucket" {
  type = string
}

variable "prefix" {
  type    = string
  default = "test"
}

variable "wrkspc_folders" {
  description = "Map of the researcher name to folder id"
  default     = {}
  # Example:
  # default = {
  #   "workspace-1" = "folders/<FOLDER_ID>"
  # }  
}

variable "enforce" {
  description = "Whether this policy is enforce."
  type        = bool
  default     = true
}

variable "set_disable_sa_create" {
  description = "Enable the Disable Service Account Creation policy"
  type        = bool
  default     = true
}

variable "project_admins" {
  description = "Name of the Google Group for admin level access."
  type        = list(string)
  default     = []
}

variable "data_stewards" {
  description = "List of or users of data stewards for this research initiative. Grants access to initiative bucket in `data-ingress`, `data-ops`. Prefix with `user:foo@bar.com`. DO NOT INCLUDE GROUPS, breaks the VPC Perimeter."
  type        = list(string)
  default     = []
}

variable "external_users_vpc" {
  description = "List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC."
  type        = list(string)
  default     = []
}

#--------------------------------------
# PROJECT LABELS, if any
#--------------------------------------

variable "lbl_department" {
  description = "Department. Used as part of the project name."
  type        = string
  default     = "pii"
}