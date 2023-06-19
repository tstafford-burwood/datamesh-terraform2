variable "researcher_workspace_folders" {
  description = "List of folder to create for researcher workspaces"
  type        = list(string)
  default     = []
}

variable "audit_log_config" {
  description = "Permission type for which logging is to be configured. Can be `DATA_READ`, `DATA_WRITE`, or `ADMIN_READ`. Leave emtpy list to turn off."
  type        = list(string)
  default     = ["DATA_READ", "DATA_WRITE", "ADMIN_READ"]
}

variable "audit_service" {
  description = "Service which will be enabled for audit logging."
  type        = string
  default     = "storage.googleapis.com"
}

variable "folder_name" {
  description = "Top level folder name"
  type        = string
  default     = "HIPAA"
}

#---------------------------------------------
# ORGANIZATION POLICY VARIABLES
#---------------------------------------------

variable "vms_allowed_external_ip" {
  description = "This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}

variable "domain_restricted_sharing_allow" {
  # gcloud organizations list
  description = "List one or more Cloud Identity or Google Workspace custom IDs whose principals can be added to IAM policies. Leave empty to not enable."
  type        = list(string)
  default     = []
}

variable "resource_location_restriction_allow" {
  description = "This list constraint defines the set of locations where location-based GCP resources can be created."
  type        = list(string)
  default     = ["in:us-central1-locations"]
}

variable "enforce" {
  description = "Whether this policy is enforce."
  type        = bool
  default     = true
}