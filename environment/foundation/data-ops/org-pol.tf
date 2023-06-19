locals {
  policy_for        = "project"
  orgpol_project_id = module.secure-staging-project.project_id
  orgpol_folder_id  = ""
  enable_org_policy = true # Toggle switch to enable (true) or disable (false)

}

resource "google_project_organization_policy" "disable_sa_create" {
  project    = module.secure-staging-project.project_id
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = var.enforce
  }
}

resource "google_project_organization_policy" "allowedIngressSettings" {
  # Mandatory policy when using Cloud Functions with VPC SC
  project    = module.secure-staging-project.project_id
  constraint = "cloudfunctions.allowedIngressSettings"

  list_policy {
    allow {
      values = ["ALLOW_ALL"] # was `ALLOW_INTERNAL_ONLY`
    }

  }
}

resource "google_project_organization_policy" "allowedVpcConnectorEgress" {
  # Mandatory policy when using Cloud Functions with VPC SC
  project    = module.secure-staging-project.project_id
  constraint = "cloudfunctions.allowedVpcConnectorEgressSettings"

  list_policy {
    allow {
      values = ["ALL_TRAFFIC"]
    }

  }
}

resource "google_project_organization_policy" "resourceLocationRestrcition" {
  # Cloud Functions uses Cloud Build and GCR.io. GCR.io places these containers in the
  # us-locations and needs to be allowed.
  # Other option is to create a private repo and point Cloud Founctions to it.
  project    = module.secure-staging-project.project_id
  constraint = "gcp.resourceLocations"

  list_policy {
    allow {
      values = ["in:us-central1-locations", "in:us-locations"]
    }

  }
}

resource "google_project_organization_policy" "requireVPCConnector" {
  # Mandatory policy when using Cloud Functions with VPC SC
  project    = module.secure-staging-project.project_id
  constraint = "cloudfunctions.requireVPCConnector"

  boolean_policy {
    enforced = true
  }
}


resource "time_sleep" "wait_60_seconds" {
  # Setting a timer allows for the org policy time to get set
  depends_on = [
    google_project_organization_policy.disable_sa_create,
    module.secure-staging-project
  ]

  create_duration = "120s"
}