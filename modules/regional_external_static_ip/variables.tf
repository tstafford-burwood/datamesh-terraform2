#--------------------------------------
# REGIONAL EXTERNAL STATIC IP VARIABLES
#--------------------------------------

variable "regional_external_static_ip_name" {
  description = "The name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
  type        = string
  default     = ""
}

variable "regional_external_static_ip_project_id" {
  description = "The project ID to provision this resource into."
  type        = string
  default     = ""
}

variable "regional_external_static_ip_address_type" {
  description = "The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL."
  type        = string
  default     = "EXTERNAL"
}

variable "regional_external_static_ip_description" {
  description = "The description to attach to the IP address."
  type        = string
  default     = "Created with Terraform"
}

variable "regional_external_static_ip_network_tier" {
  description = "The networking tier used for configuring this address. If this field is not specified, it is assumed to be PREMIUM. Possible values are PREMIUM and STANDARD."
  type        = string
  default     = "PREMIUM"
}

variable "regional_external_static_ip_region" {
  description = "The Region in which the created address should reside. If it is not provided, the provider region is used."
  type        = string
  default     = ""
}