#------------------------------------
# REGIONAL EXTERNAL STATIC IP OUTPUTS
#------------------------------------

output "regional_external_static_ip_self_link" {
  description = "Self link to the URI of the created resource."
  value       = google_compute_address.regional_external_static_ip.self_link
}