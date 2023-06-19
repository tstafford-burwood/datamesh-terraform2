locals {
  policy_for        = "folder"
  orgpol_project_id = ""
  orgpol_folder_id  = google_folder.environment.id # Assign Org Policies to the top folder
  enable_org_policy = true                         # Toggle switch to enable (true) or disable (false)
}

module "disable_automatic_iam_for_default_sa" {
  # DISABLE AUTOMATIC IAM GRANTS FOR DEFAULT SERVICE ACCOUNTS
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "detailed_audit_logging" {
  # DETAILED AUDIT LOGGING MODE
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/gcp.detailedAuditLoggingMode"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "disable_sa_creation" {
  # DISABLE SERVICE ACCOUNT CREATION
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/iam.disableServiceAccountCreation"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "disable_sa_key_creation" {
  count = local.enable_org_policy ? 1 : 0
  # DISABLE SERVICE ACCOUNT KEY CREATION
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/iam.disableServiceAccountKeyCreation"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "disable_vm_nested_virtualization" {
  # DISABLE VM NESTED VIRTUALIZATION
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/compute.disableNestedVirtualization"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "enforce_public_access_prevention" {
  # ENFORCE PUBLIC ACCESS PREVENTION ON GCS BUCKETS
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/storage.publicAccessPrevention"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "enforce_uniform_bucket_level_access" {
  # ENFORCE UNIFORM BUCKET LEVEL ACCESS
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/storage.uniformBucketLevelAccess"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "vm_os_login" {
  # REQUIRE OS LOGIN FOR VMs
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/compute.requireOsLogin"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "shielded_vms" {
  # REQUIRE SHIELDED VMs
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/compute.requireShieldedVm"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "restrict_public_ip_on_sql_instances" {
  # RESTRICT PUBLIC IP ACCESS ON CLOUD SQL INSTANCES
  count       = local.enable_org_policy ? 1 : 0
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 5.0"
  constraint  = "constraints/sql.restrictPublicIp"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.orgpol_project_id
  folder_id   = local.orgpol_folder_id
  enforce     = var.enforce

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}


module "vm_allowed_external_ip" {
  count = local.enable_org_policy ? 1 : 0
  # LIST OF VMs ALLOWED TO HAVE AN EXTERNAL IP
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 5.0"
  constraint        = "constraints/compute.vmExternalIpAccess"
  policy_type       = "list"
  policy_for        = local.policy_for
  project_id        = local.orgpol_project_id
  folder_id         = local.orgpol_folder_id
  enforce           = var.enforce
  allow             = var.vms_allowed_external_ip
  allow_list_length = length(var.vms_allowed_external_ip)

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

resource "google_folder_organization_policy" "domain_restricted_shared" {
  # SDE DOMAIN RESTRICTED SHARING
  folder     = local.orgpol_folder_id
  constraint = "iam.allowedPolicyMemberDomains"
  list_policy {
    allow {
      values = var.domain_restricted_sharing_allow
    }
  }

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "resource_location_restriction" {
  # RESOURCE LOCATION RESTRICTION
  count             = local.enable_org_policy ? 1 : 0
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 5.0"
  constraint        = "constraints/gcp.resourceLocations"
  policy_type       = "list"
  policy_for        = local.policy_for
  project_id        = local.orgpol_project_id
  folder_id         = local.orgpol_folder_id
  allow             = var.resource_location_restriction_allow
  allow_list_length = length(var.resource_location_restriction_allow)

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

