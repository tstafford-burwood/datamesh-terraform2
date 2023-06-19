#------------------------
# PACKER PROJECT FACTORY
#------------------------

variable "image_project_iam_roles" {
  description = "The IAM role(s) to assign to the member at the defined project."
  type        = list(string)
  default = [
    "roles/deploymentmanager.editor", # Provides the permissions necessary to create and manage deployments.
    "roles/artifactregistry.admin",   # Administrator access to create and manage repositories.
    "roles/compute.admin",            # Full control of all Compute Engine resources.
    "roles/editor"
  ]
}

variable "enforce" {
  description = "Whether this policy is enforced."
  type        = bool
  default     = true
}

variable "set_resource_location" {
  description = "Enable org policy to set resource location restriction"
  type        = bool
  default     = false
}

variable "set_external_ip_policy" {
  description = "Enable org policy to allow External (Public) IP addresses on virtual machines."
  type        = bool
  default     = true
}

variable "set_disable_sa_create" {
  description = "Enable the Disable Service Account Creation policy"
  type        = bool
  default     = true
}


variable "inherit" {
  description = "Inherit from parent"
  type        = bool
  default     = false
}

#--------------------------------------
# PROJECT LABELS, if any
#--------------------------------------