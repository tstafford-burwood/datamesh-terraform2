#-----------------------------------------
# ORG POLICIES exceptions
# Set at the project level
#-----------------------------------------

resource "google_project_organization_policy" "disable_sa_create" {
  project    = module.image-project.project_id
  constraint = "iam.disableServiceAccountCreation"

  boolean_policy {
    enforced = var.set_disable_sa_create
  }
}

resource "google_project_organization_policy" "external_ip" {
  # By default, this is Org Pol on the project is enabled and allows the image build vm
  # to have an external IP
  count      = var.set_external_ip_policy ? 1 : 0
  project    = module.image-project.project_id
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    inherit_from_parent = var.inherit
    allow {
      values = [
        "projects/${module.image-project.project_id}/zones/${local.image_default_region}-b/instances/${local.image_builder_vm}",
      ]
    }
  }
}

resource "google_project_organization_policy" "resource_location" {
  # By default, this Org Pol on the project is NOT ENABLED. It's here to help control where
  # the Packer cloudbuild script can place the image which is in the US location
  count      = var.set_resource_location ? 1 : 0
  project    = module.image-project.project_id
  constraint = "gcp.resourceLocations"

  list_policy {
    inherit_from_parent = false
    allow {
      values = [
        "in:us-locations",
      ]
    }
  }
}

resource "time_sleep" "wait_60_seconds" {
  # Setting a timer allows for the org policy time to get set
  depends_on = [
    google_project_organization_policy.resource_location,
    google_project_organization_policy.external_ip,
    google_project_organization_policy.disable_sa_create
  ]

  create_duration = "120s"
}