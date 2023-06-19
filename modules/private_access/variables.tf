variable "project_id" {
  description = "Project ID for Private Service Connect."
  type        = string
}

variable "vpc_network" {
  description = "Name of the VPC network to peer."
  type        = string
}

variable "address" {
  description = "First IP address of the IP range to allocate to instances and other Private Service Access services. If not set, GCP will pick a valid one for you."
  type        = string
  default     = ""
}

variable "description" {
  description = "An optional description of the Global Address resource."
  type        = string
  default     = "Terraform managed"
}

variable "prefix_length" {
  description = "Prefix length of the IP range reserved for Cloud SQL instances and other Private Service Access services. Defaults to /16."
  type        = number
  default     = 16
}

variable "ip_version" {
  description = "IP Version for the allocation. Can be IPV4 or IPV6."
  type        = string
  default     = "IPV4"
}

variable "labels" {
  description = "The key/value labels for the IP range allocated to the peered network."
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "The purpose of the resource. Possible values include:`VPC_PEERING` or `PRIVATE_SERVICE_CONNECT`"
  type        = string
  default     = "VPC_PEERING"

}