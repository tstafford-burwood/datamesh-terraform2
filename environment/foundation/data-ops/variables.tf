#---------------------------------
# SECURE STAGING PROJECT VARIABLES
#---------------------------------

variable "data_ops_admin_project_iam_roles" {
  description = "The IAM role(s) to assign to the `Admins` at the defined project."
  type        = list(string)
  default = [
    "roles/bigquery.admin",        # Full access to BigQuery
    "roles/storage.objectViewer",  # View objects in buckets
    "roles/storage.objectCreator", # Create objects, but not delete or overwrite objects
    "roles/composer.admin",        # Full access to Cloud Composer
    "roles/composer.environmentAndStorageObjectAdmin",
    "roles/run.admin",        # Full access to Cloud Run
    "roles/monitoring.admin", # Full access to monitoring, used by Cloud Composer
    "roles/notebooks.admin",  # Start/stop and create notebooks
    "roles/logging.admin",    # Full access to Logging
    "roles/integrations.integrationAdmin",
    #"roles/integrationAdmin", # Full access to all Application Integration resources
    # "roles/owner",                      # TEMP - BREAK GLASS

  ]
}

# variable "stewards_project_iam_roles" {
#   description = "The IAM role(s) to assign to the `Data Stewards` at the defined project."
#   type        = list(string)
#   default = [
#     "roles/bigquery.user",           # Run jobs
#     "roles/bigquery.dataViewer",     # Can enumerate all datasets in the project
#     "roles/storage.objectViewer",    # View objects in buckets
#     "roles/storage.objectCreator",   # Create objects, but not delete or overwrite objects
#     "roles/container.clusterViewer", # Provides access to get and list GKE clusters - used to view Composer Environemtn
#     "roles/composer.user",
#     "roles/composer.environmentAndStorageObjectViewer",
#     "roles/monitoring.viewer", # read-only access to get and list info about all monitoring data
#     "roles/notebooks.viewer",
#     "roles/bigquery.admin",
#     "roles/logging.viewer", # see longs from within Cloud Composer
#     "roles/dlp.admin",
#   ]
# }

#----------------------------------------------------
# FOLDER IAM MEMBER VARIABLES - DLP API SERVICE AGENT
#----------------------------------------------------

variable "dlp_service_agent_iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined folder."
  type        = list(string)
  default     = ["roles/dlp.jobsEditor", "roles/dlp.user", ]
}

#--------------------------------------
# PROJECT LABELS, if any
#--------------------------------------


#---------------------------------------------
# ORGANIZATION POLICY VARIABLES
#---------------------------------------------

variable "srde_project_vms_allowed_external_ip" {
  description = "This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}

variable "srde_project_domain_restricted_sharing_allow" {
  description = "List one or more Cloud Identity or Google Workspace custom IDs whose principals can be added to IAM policies. Leave empty to not enable."
  type        = list(string)
  default     = []
}

variable "srde_project_resource_location_restriction_allow" {
  description = "This list constraint defines the set of locations where location-based GCP resources can be created."
  type        = list(string)
  default     = ["in:us-locations"]
}

variable "enforce" {
  description = "Whether this policy is enforce."
  type        = bool
  default     = true
}