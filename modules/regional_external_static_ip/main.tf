#-----------------------------------
# REGIONAL EXTERNAL STATIC IP MODULE
#-----------------------------------

// FUNCTIONALITY IN THIS MODULE IS ONLY FOR A REGIONAL EXTERNAL STATIC IP

resource "google_compute_address" "regional_external_static_ip" {

  // REQUIRED
  name = var.regional_external_static_ip_name

  // OPTIONAL
  project      = var.regional_external_static_ip_project_id
  address_type = var.regional_external_static_ip_address_type
  description  = var.regional_external_static_ip_description
  network_tier = var.regional_external_static_ip_network_tier
  region       = var.regional_external_static_ip_region
}