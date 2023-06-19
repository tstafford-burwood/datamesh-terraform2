#-----------------------------------------
# RESEARCHER WORKSPACE - PROJECT VARIABLES
#-----------------------------------------

variable "enforce" {
  description = "Whether this policy is enforce."
  type        = bool
  default     = true
}

#--------------------------------------
# DATALAKE PROJECT IAM MEMBER VARIABLES
#--------------------------------------

variable "project_iam_admins_list" {
  description = "The IAM role(s) to assign to the member at the defined project."
  type        = list(string)
  default = [
    "roles/storage.admin",
    "roles/bigquery.admin",
    # "roles/owner" # TEMP - BREAK GLASS
  ]
}

variable "stewards_project_iam_roles" {
  description = "The IAM role(s) to assign to the member at the defined project."
  type        = list(string)
  default = [
    "roles/browser", # Read access to browse hiearchy for the project
    "roles/storage.objectViewer",
    "roles/bigquery.dataViewer",
    "roles/bigquery.filteredDataViewer",
    "roles/bigquery.metadataViewer",
    "roles/bigquery.resourceViewer",
  ]
}

# variable "data_lake_domain_restricted_sharing_allow" {
#   description = "List one or more Cloud Identity or Google Workspace custom IDs whose principals can be added to IAM policies. Leave empty to not enable."
#   type        = list(string)
#   default     = []
# }

#--------------------------------------
# PROJECT LABELS, if any
#--------------------------------------


#--------------------------------------
# BUCKET VARIABLES
#--------------------------------------

variable "force_destroy" {
  description = "To allow terraform to destroy the bucket even if there are objects in it."
  type        = bool
  default     = true
}
