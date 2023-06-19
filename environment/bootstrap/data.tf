data "google_project" "cloudbuild_project" {
  # Read the project ID
  project_id = var.project_id
}

data "google_billing_account" "billing_id" {
  # Read the billing account id
  display_name = var.billing_display_name
  open         = true
}

locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}