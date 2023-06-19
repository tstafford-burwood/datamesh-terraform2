module "gcs_bucket_researcher_data_egress" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 3.0"

  project_id = module.researcher-data-egress-project.project_id
  prefix     = "${var.prefix}-${local.researcher_workspace_name}"
  names      = ["external-egress"]

  # OPTIONAL FIELDS 
  randomize_suffix = true
  location         = var.region
  storage_class    = "STANDARD"
  set_admin_roles  = false
  set_viewer_roles = true
  viewers          = var.external_users_vpc
  force_destroy = {
    "external-egress" = true
  }
}

resource "google_storage_bucket" "function_archive_storage" {
  # Storage bucket for function archives (.zip), so they can be deployed.
  project                     = local.staging_project_id
  location                    = var.region
  name                        = format("%s-%s", "cf-deployments", module.researcher-data-egress-project.project_id)
  force_destroy               = true
  uniform_bucket_level_access = true
}