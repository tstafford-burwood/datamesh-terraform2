# Some org policies are set at the folder level. These policies must be disabled before deploying.

resource "google_project_organization_policy" "disable_sa_create" {
  project    = local.staging_project_id
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = var.enforce
  }
}

resource "google_project_organization_policy" "os_login" {
  project    = local.staging_project_id
  constraint = "compute.requireOsLogin"

  boolean_policy {
    enforced = var.enforce
  }
}

resource "google_project_organization_policy" "shielded_vms" {
  project    = local.staging_project_id
  constraint = "compute.requireShieldedVm"

  boolean_policy {
    enforced = var.enforce
  }
}

resource "time_sleep" "wait_120_seconds" {
  # Setting a timer allows for the org policy time to get set
  depends_on = [
    google_project_organization_policy.disable_sa_create,
    google_project_organization_policy.os_login,
    google_project_organization_policy.shielded_vms
  ]

  create_duration = "120s"
}