#----------------------------------------------------------------------------
# Setup private access connection
#----------------------------------------------------------------------------

data "google_compute_network" "default" {
  # Read the VPC network name, if provided
  name    = var.vpc_network
  project = var.project_id
}

resource "google_compute_global_address" "private_service_connect" {
  # Create the required private service access between this project and the google project
  provider      = google-beta
  project       = var.project_id
  name          = format("google-managed-services-%s", var.vpc_network)
  description   = var.description
  address_type  = "INTERNAL"
  purpose       = var.purpose
  network       = data.google_compute_network.default.self_link
  address       = var.address
  prefix_length = var.prefix_length
  ip_version    = var.ip_version
  labels        = var.labels
}

resource "google_service_networking_connection" "privce_service-access" {
  # Creates the peering with the producer network
  provider                = google-beta
  network                 = data.google_compute_network.default.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connect.name]
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    google_service_networking_connection.privce_service-access
  ]
}