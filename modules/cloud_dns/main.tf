#-----------------
# CLOUD DNS MODULE
#-----------------

module "cloud-dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.0"

  // REQUIRED
  domain     = var.cloud_dns_domain
  name       = var.cloud_dns_name
  project_id = var.cloud_dns_project_id

  // OPTIONAL
  default_key_specs_key              = var.default_key_specs_key
  default_key_specs_zone             = var.default_key_specs_zone
  description                        = var.cloud_dns_description
  dnssec_config                      = var.dnssec_config
  labels                             = var.cloud_dns_labels
  private_visibility_config_networks = var.private_visibility_config_networks
  recordsets                         = var.cloud_dns_recordsets
  target_name_server_addresses       = var.target_name_server_addresses
  target_network                     = var.cloud_dns_target_network
  type                               = var.cloud_dns_zone_type
}