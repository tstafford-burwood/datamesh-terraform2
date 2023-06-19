locals {
  suffix                         = var.common_suffix != "" ? var.common_suffix : random_id.suffix.hex
  perimeter_name                 = "rp_dwh_${var.common_name}_${local.suffix}"
  regular_service_perimeter_name = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"
  access_policy_name             = "ac_dwh_${var.common_name}_${local.suffix}"
}

resource "random_id" "suffix" {
  byte_length = 4
}


module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 5.0"

  policy      = var.access_context_manager_policy_id
  name        = local.access_policy_name
  description = var.description

  members = var.perimeter_members

  ip_subnetworks = var.access_level_ip_subnetworks
  regions        = var.access_level_regions
}

module "service_perimeter" {
  source              = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version             = "~> 5.0"
  policy              = var.access_context_manager_policy_id
  perimeter_name      = local.perimeter_name
  description         = var.perimeter_description
  resource_keys       = var.resource_keys
  resources           = var.resources
  restricted_services = var.restricted_services
  access_levels       = [module.access_level_members.name]
  egress_policies     = var.egress_policies
  ingress_policies    = var.ingress_policies
}