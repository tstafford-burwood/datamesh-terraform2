variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zone where the instances should be created. If not specified, instances will be spread across available zones in the region."
}

variable "project" {
  type = string
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
  description = "The machine type for the Filemage VM(s)"
}

variable "filemage_domain" {
  description = "The domain name that the FileMage service will be hosted on"
  type        = string
  default     = "127.0.0.1"
}

variable "service_account_email" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "vpc_self_link" {
  type = string
}

variable "vpc_id" {
  type = string
}