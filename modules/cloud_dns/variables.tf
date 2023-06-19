#--------------------
# CLOUD DNS VARIABLES
#--------------------

// REQUIRED VARIABLES

variable "cloud_dns_domain" {
  description = "Zone domain, must end with a period."
  type        = string
}

variable "cloud_dns_name" {
  description = "Zone name, must be unique within the project."
  type        = string
}

variable "cloud_dns_project_id" {
  description = "Project id for the zone."
  type        = string
}

// OPTIONAL VARIABLES

variable "default_key_specs_key" {
  description = "Object containing default key signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "default_key_specs_zone" {
  description = "Object containing default zone signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "cloud_dns_description" {
  description = "zone description (shown in console)"
  type        = string
  default     = "Managed by Terraform"
}

variable "dnssec_config" {
  description = "Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details"
  type        = any
  default     = {}
}

variable "cloud_dns_labels" {
  description = "A set of key/value label pairs to assign to this ManagedZone"
  type        = map(any)
  default     = {}
}

variable "private_visibility_config_networks" {
  description = "List of VPC self links that can see this zone."
  type        = list(string)
  default     = []
}

variable "cloud_dns_recordsets" {
  description = "List of DNS record objects to manage, in the standard Terraform DNS structure."
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "target_name_server_addresses" {
  description = "List of target name servers for forwarding zone."
  default     = []
  type        = list(map(any))
}

variable "cloud_dns_target_network" {
  description = "Peering network."
  type        = string
  default     = ""
}

variable "cloud_dns_zone_type" {
  description = "Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'."
  type        = string
  default     = "private"
}