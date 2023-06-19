variable "trusted_scientists" {
  description = "The list of trusted users."
  type        = list(string)
  default     = []
}

variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "network" {
  description = "The name of the VPC that this instance is in. Format: projects/{project_id}/global/networks/{network_id}"
  type        = string
}

variable "subnet" {
  description = "The name of the subnet that this instance is in. Format projects/{project_id}/regions/{region}/subnetworks/{subnetwork_id}"
  type        = string
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

variable "data_disk_type" {
  description = "Possible disk types for notebook instances."
  type        = string
  default     = ""
}

variable "data_disk_size_gb" {
  description = "The size of the data disk in GB attached to the instance. Mininum of 100"
  type        = number
  default     = 0
}

variable "vm_image_project" {
  description = "The name of the Google Cloud project that this VM image belongs to. Format: projects/{project_id}"
  type        = string
  default     = "deeplearning-platform-release"
}

variable "image_family" {
  description = "Use this VM image family to find the image; the newest image in this family will be used."
  type        = string
  default     = "tf-latest-cpu"
}

variable "no_public_ip" {
  description = "No public IP will be assigned to this instance."
  type        = string
  default     = true
}

variable "no_proxy_access" {
  description = "The notebook instance will not register with the proxy."
  type        = string
  default     = false
}

variable "disable_root" {
  description = "Disable root access on the notebook."
  type        = string
  default     = true
}

variable "disable_downloads" {
  description = "Disable the ability to download from the notebook."
  type        = string
  default     = true
}

variable "disable_nbconvert" {
  description = "Disable the ability to convert files to PDF, XLS, etc and download."
  type        = string
  default     = true
}

variable "disable_terminal" {
  description = "Disable terminals in the notebook."
  type        = string
  default     = true
}

variable "region" {
  description = "The region the subnet is deployed into."
  type        = string
  default     = "us-central1"
}