locals {
  project = format("%s-%s-%s", var.prefix, var.lbl_department, var.researcher_workspace_name)
  prefix  = substr(local.project, 0, 17)

  # drop the prefix `user` from each steward value to create a string of email addresses
  trim_prefix    = [for steward in var.data_stewards : trimprefix(steward, "user:")] # drop the `user:` prefix
  steward_emails = join(",", local.trim_prefix)                                      # convert the list to a string
}

#----------------------------------------------------------------------------------------------
# DATA EGRESS - PROJECT
#----------------------------------------------------------------------------------------------

module "researcher-data-egress-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name                        = format("%s-%s", lower(local.prefix), "egress")
  org_id                      = local.org_id
  billing_account             = local.billing_account_id
  folder_id                   = local.srde_folder_id
  random_project_id           = true
  activate_apis               = ["storage.googleapis.com", "cloudasset.googleapis.com"]
  default_service_account     = "delete"
  disable_dependent_services  = true
  disable_services_on_destroy = true
  create_project_sa           = false
  labels = {
    environment = var.prefix
    department  = var.lbl_department
  }
}

resource "google_compute_project_metadata" "researcher_egress_project" {
  project = module.researcher-data-egress-project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}