variable "trusted_scientists" {
  description = "The list of individual trusted users. Use their full email address like `foo@example.com`."
  type        = list(string)
  default     = []
}

variable "access_mode" {
  description = "Access modes determine who can use a notebook instance and which creds are used to call Google APIs. Cannot be changed once notebook is created. Values can be `SINGLE_USER` or `SERVICE_ACCOUNT`."
  type        = string
  default     = ""
}

variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "disable_downloads" {
  description = "Option to disable downloads from the managed notebook."
  type        = bool
  default     = true
}

variable "disable_nbconvert" {
  description = "Option to disable nbconvert from the managed notebook."
  type        = bool
  default     = true
}

variable "enable_secure_boot" {
  description = "Enable secure boot for managed notebook."
  type        = bool
  default     = false
}

variable "enable_vtpm" {
  description = "Enable vTPM for managed notebook."
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring"
  type        = bool
  default     = true
}

variable "repository" {
  description = "Path to the image repository"
  type        = string
  default     = "gcr.io/deeplearning-platform-release/base-cpu"
}

variable "tag" {
  description = "The tag of the container image."
  type        = string
  default     = "lastest"
}

variable "notebook_name_prefix" {
  description = "Prefix for notebooks indicating in higher trusted environment."
  type        = string
  default     = "trusted"
}

variable "machine_type" {
  description = "VM Image type"
  type        = string
  default     = "n1-standard-1"
}

variable "boot_disk_type" {
  description = "Possible disk types for notebook instances."
  type        = string
  default     = "PD_STANDARD"
}

variable "boot_disk_size" {
  description = "The boot disks size. Minimum is 100."
  type        = number
  default     = 100
}

variable "region" {
  description = "The subnetwork region"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "The name of the VPC that this instance is in. Format: projects/{project_id}/global/networks/{network_id}"
  type        = string
  default     = ""
}

variable "subnet" {
  description = "The name of the subnet that this instance is in. Format projects/{project_id}/regions/{region}/subnetworks/{subnetwork_id}"
  type        = string
  default     = ""
}

variable "reserved_ip_range" {
  description = "Reserved IP Range name is used for VPC Peering. The subnetwork allocation will use the range `name` if it's assigned."
  type        = string
  default     = ""
}

variable "role" {
  description = "IAM role to be assigned to instance."
  type        = string
  default     = "roles/notebooks.viewer"
}

variable "idle_shutdown" {
  description = "Runtime will automatically shutdown after `idle_shutdown_timeout`."
  type        = string
  default     = true
}

variable "idle_shutdown_timeout" {
  description = "Time in minutes to wait before shuting down runtime."
  type        = number
  default     = 30
}