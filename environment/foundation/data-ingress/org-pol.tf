#-----------------------------------------
# Locals
#-----------------------------------------

locals {
  policy_for        = "project"
  orgpol_project_id = module.project.project_id
  orgpol_folder_id  = ""
  enable_org_policy = true # Toggle switch to enable (true) or disable (false)

  vms_allowed_external_ip = [""]
}

#-----------------------------------------
# ORG POLICIES
# Set at the project level
#-----------------------------------------

module "disable_sa_creation" {
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/iam.disableServiceAccountCreation"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce
}

resource "time_sleep" "wait_60_seconds" {
  # Setting a timer allows for the org policy time to get set
  depends_on = [
    module.disable_sa_creation
  ]

  create_duration = "60s"
}