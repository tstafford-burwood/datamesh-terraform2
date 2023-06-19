variable "billing_account" {
  description = "Google Billing Account ID. If left blank, the value from constants.tf will be used."
  type        = string
  default     = ""
}

variable "region" {
  description = "The default region to place resources. If left blank, the value from constants.tf will be used."
  type        = string
  default     = ""
}

variable "lbl_department" {
  description = "Department. Used as part of the project name."
  type        = string
  default     = "pii"
}

variable "num_instances" {
  description = "Number of instances to create."
  type        = number
  default     = 0
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  type        = string
  default     = "deep-learning-vm"
}

variable "golden_image_version" {
  description = "Retrieves the specific custom image version from the image project."
  type        = string
  default     = ""
}

variable "researcher_workspace_name" {
  description = "Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist."
  type        = string
  default     = "workspace-1"
}

variable "set_vm_os_login" {
  description = "Enable the requirement for OS login for VMs"
  type        = bool
  default     = true
}

variable "set_disable_sa_create" {
  description = "Enable the Disable Service Account Creation policy"
  type        = bool
  default     = true
}

variable "researchers" {
  description = "The list of users who get their own managed notebook. Do not pre-append with `user`."
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

variable "project_admins" {
  description = "Name of the Google Group for admin level access."
  type        = list(string)
  default     = []
}

variable "deploy_notebook" {
  description = "deploys vertex ai notebook in the workspace"
  type        = bool
  default     = false
}