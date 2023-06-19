output "address" {
  value       = google_compute_global_address.private_service_connect.address
  description = "First IP of the reserved range."
}

output "google_compute_global_address_name" {
  value       = google_compute_global_address.private_service_connect.name
  description = "URL of the reserved range."
}

output "peering_completed" {
  value       = null_resource.dependency_setter.id
  description = "Use for enforce ordering between resource creation"
}
