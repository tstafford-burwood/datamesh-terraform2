module "project-iam-admins" {
  # Add admins at project level
  source = "../../../modules/iam/project_iam"

  for_each = toset(module.constants.value.image-project-admins)

  project_id            = module.image-project.project_id
  project_member        = each.value
  project_iam_role_list = var.image_project_iam_roles
}

resource "google_service_account" "image-builder" {
  account_id   = "${local.environment[terraform.workspace]}-image-builder"
  display_name = "Packer service account"
  description  = "Managed by Terraform"
  project      = module.image-project.project_id

  depends_on = [
    resource.time_sleep.wait_60_seconds
  ]
}

module "image-builder-iam-roles" {
  # Assign roles to Packer service account
  # https://developer.hashicorp.com/packer/plugins/builders/googlecompute
  # This will allow Packer to authenticate to Google Cloud without having to bake in a separate credential/authentication file.
  source                = "../../../modules/iam/project_iam"
  project_id            = module.image-project.project_id
  project_member        = "serviceAccount:${google_service_account.image-builder.email}"
  project_iam_role_list = ["roles/compute.instanceAdmin.v1", "roles/iam.serviceAccountUser", "roles/artifactregistry.reader"]
}

resource "google_service_account_iam_binding" "sa-image-builder-token-creators" {
  service_account_id = google_service_account.image-builder.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:${local.cloudbuild_sa}"]
}