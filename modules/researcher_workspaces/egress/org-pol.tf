#-----------------------------------------
# ORG POLICIES exceptions
#-----------------------------------------

resource "google_project_organization_policy" "disable_sa_create" {
  project    = module.researcher-data-egress-project.project_id
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = var.set_disable_sa_create
  }
}

resource "time_sleep" "wait_60_seconds" {
  # Setting a timer allows for the org policy time to get set
  depends_on = [
    google_project_organization_policy.disable_sa_create
  ]

  create_duration = "120s"
}