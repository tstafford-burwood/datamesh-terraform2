#-----------------------------------------
# ORG POLICIES exceptions
# Set at the project level
#-----------------------------------------

resource "google_project_organization_policy" "disable_sa_create" {
  project    = module.workspace_project.project_id
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = var.set_disable_sa_create
  }
}

resource "google_project_organization_policy" "vm_os_login" {
  project    = module.workspace_project.project_id
  constraint = "compute.requireOsLogin"

  boolean_policy {
    enforced = var.set_vm_os_login
  }
}


resource "time_sleep" "wait_60_seconds" {
  # Setting a timer allows for the org policy time to get set
  depends_on = [
    google_project_organization_policy.disable_sa_create,
    google_project_organization_policy.vm_os_login
  ]

  create_duration = "300s"
}

resource "google_project_organization_policy" "trustedimage_project_policy" {
  count      = var.set_trustedimage_project_policy ? 1 : 0
  constraint = "compute.trustedImageProjects"
  project    = module.workspace_project.project_id

  list_policy {
    allow {
      values = [
        "is:projects/deeplearning-platform-release", # A google owned project with data science tools
        "is:projects/${local.imaging_project_id}"
      ]
    }
  }
}