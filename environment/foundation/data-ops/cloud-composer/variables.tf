#-------------------------
# CLOUD COMPOSER VARIABLES
#-------------------------

variable "srde_project_vms_allowed_external_ip" {
  description = "This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}

variable "composer_iam_roles" {
  description = "The IAM role(s) to assign to the Cloud Compuser service account, defined at the folder."
  type        = list(string)
  default = [
    "roles/composer.worker",
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/bigquery.dataOwner",
    "roles/dlp.jobsEditor",
    "roles/storage.objectAdmin",
    "roles/bigquery.jobUser",
    "roles/bigquery.dataOwner",
    "roles/bigquery.jobUser"
  ]
}

// OPTIONAL

variable "allowed_ip_range" {
  description = "The IP ranges which are allowed to access the Apache Airflow Web Server UI."
  type = list(object({
    value       = string
    description = string
  }))
  default = []
}

variable "cloud_sql_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for Cloud SQL."
  type        = string
  default     = "10.4.0.0/24"
}

# variable "database_machine_type" {
#   description = "The machine type to setup for the SQL database in the Cloud Composer environment."
#   type        = string
#   default     = "db-n1-standard-4"
# }

# variable "disk_size" {
#   description = "The disk size in GB for nodes."
#   type        = string
#   default     = "50"
# }

variable "env_variables" {
  description = "Variables of the airflow environment."
  type        = map(string)
  default     = {}
}

variable "environment_size" {
  type        = string
  description = "The environment size controls the performance parameters of the managed Cloud Composer infrastructure that includes the Airflow database. Values for environment size are: ENVIRONMENT_SIZE_SMALL, ENVIRONMENT_SIZE_MEDIUM, and ENVIRONMENT_SIZE_LARGE."
  default     = "ENVIRONMENT_SIZE_SMALL"
}

variable "image_version" {
  description = "The version of Airflow running in the Cloud Composer environment. Latest version found [here](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions)."
  type        = string
  default     = "composer-2.1.15-airflow-2.5.1"
  #default     = "composer-2.1.11-airflow-2.4.3"
}

# variable "gke_machine_type" {
#   description = "Machine type of Cloud Composer nodes."
#   type        = string
#   default     = "n1-standard-2"
# }

variable "master_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the master."
  type        = string
  default     = null
}

# variable "node_count" {
#   description = "Number of worker nodes in the Cloud Composer Environment."
#   type        = number
#   default     = 3
# }

variable "oauth_scopes" {

  description = "Google API scopes to be made available on all node."
  type        = set(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "pypi_packages" {
  type        = map(string)
  description = " Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. \"numpy\")."
  default     = {}
}

variable "scheduler" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
    count      = number
  })
  default = {
    cpu        = 0.5
    memory_gb  = 1.875
    storage_gb = 1
    count      = 1
  }
  description = "Configuration for resources used by Airflow schedulers."
}

variable "web_server" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
  })
  default = {
    cpu        = 0.5
    memory_gb  = 1.875
    storage_gb = 1
  }
  description = "Configuration for resources used by Airflow web server."
}

variable "web_server_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the web server."
  type        = string
  default     = "10.3.0.0/29"
}

variable "worker" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
    min_count  = number
    max_count  = number
  })
  default = {
    cpu        = 0.5
    memory_gb  = 1.875
    storage_gb = 1
    min_count  = 1
    max_count  = 3
  }
  description = "Configuration for resources used by Airflow workers."
}

# variable "web_server_machine_type" {
#   description = "The machine type to setup for the Apache Airflow Web Server UI."
#   type        = string
#   default     = "composer-n1-webserver-4"
# }

variable "enforce" {
  description = "Whether this policy is enforced."
  type        = bool
  default     = true
}