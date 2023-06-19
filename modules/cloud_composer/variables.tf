#-------------------------
# CLOUD COMPOSER VARIABLES
#-------------------------

// REQUIRED

variable "composer_env_name" {
  description = "Name of Cloud Composer Environment"
  type        = string
}

variable "network" {
  type        = string
  description = "The VPC network to host the Composer cluster."
}

variable "project_id" {
  description = "Project ID where Cloud Composer Environment is created."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to host the Composer cluster."
  type        = string
}

// OPTIONAL

variable "airflow_config_overrides" {
  description = "Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example \"core-dags_are_paused_at_creation\"."
  type        = map(string)
  default     = {}
}

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
  default     = null
}

variable "composer_service_account" {
  description = "Service Account for running Cloud Composer."
  type        = string
  default     = null
}

variable "database_machine_type" {
  description = "The machine type to setup for the SQL database in the Cloud Composer environment."
  type        = string
  default     = "db-n1-standard-2"
}

variable "disk_size" {
  description = "The disk size in GB for nodes."
  type        = string
  default     = "50"
}

variable "enable_private_endpoint" {
  description = "Configure the ability to have public access to the cluster endpoint. If private endpoint is enabled, connecting to the cluster will need to be done with a VM in the same VPC and region as the Composer environment. Additional details can be found [here](https://cloud.google.com/composer/docs/concepts/private-ip#cluster)."
  type        = bool
  default     = false
}

variable "env_variables" {
  description = "Variables of the airflow environment."
  type        = map(string)
  default     = {}
}

variable "image_version" {
  description = "The version of Airflow running in the Cloud Composer environment."
  type        = string
  default     = null
}

variable "labels" {
  description = "The resource labels (a map of key/value pairs) to be applied to the Cloud Composer."
  type        = map(string)
  default     = {}
}

variable "gke_machine_type" {
  description = "Machine type of Cloud Composer GKE nodes."
  type        = string
  default     = "n1-standard-1"
}

variable "master_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the master."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of worker nodes in the Cloud Composer Environment."
  type        = number
  default     = 3
}

variable "oauth_scopes" {
  description = "Google API scopes to be made available on all node."
  type        = set(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "pod_ip_allocation_range_name" {
  description = "The name of the cluster's secondary range used to allocate IP addresses to pods."
  type        = string
  default     = null
}

variable "pypi_packages" {
  description = "Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. \"numpy\")."
  type        = map(string)
  default     = {}
}

variable "python_version" {
  description = "The default version of Python used to run the Airflow scheduler, worker, and webserver processes."
  type        = string
  default     = "3"
}

variable "region" {
  description = "Region where the Cloud Composer Environment is created."
  type        = string
  default     = "us-central1"
}

variable "service_ip_allocation_range_name" {
  description = "The name of the services' secondary range used to allocate IP addresses to the cluster."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls."
  type        = set(string)
  default     = []
}

variable "use_ip_aliases" {
  description = "Enable Alias IPs in the GKE cluster. If true, a VPC-native cluster is created."
  type        = bool
  default     = false
}

variable "web_server_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the web server."
  type        = string
  default     = null
}

variable "web_server_machine_type" {
  description = "The machine type to setup for the Apache Airflow Web Server UI."
  type        = string
  default     = "composer-n1-webserver-2"
}

variable "zone" {
  description = "Zone where the Cloud Composer nodes are created."
  type        = string
  default     = "us-central1-f"
}

// SHARED VPC SUPPORT

variable "network_project_id" {
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  type        = string
  default     = ""
}

variable "subnetwork_region" {
  description = "The subnetwork region of the shared VPC's host (for shared vpc support)"
  type        = string
  default     = ""
}