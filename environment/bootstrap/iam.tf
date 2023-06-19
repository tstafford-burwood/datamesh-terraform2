module "folder-iam-admins" {
  # Project level roles
  source        = "../../modules/iam/folder_iam"
  folder_id     = google_folder.parent.id
  folder_member = "serviceAccount:${var.cloudbuild_service_account}"
  iam_role_list = var.cloudbuild_iam_roles
}

resource "google_organization_iam_member" "policy_admin" {
  org_id = var.org_id
  role   = "roles/orgpolicy.policyAdmin"
  member = "serviceAccount:${var.cloudbuild_service_account}"
}

resource "google_billing_account_iam_member" "billing_user" {
  billing_account_id = data.google_billing_account.billing_id.id
  role               = "roles/billing.user"
  member             = "serviceAccount:${var.cloudbuild_service_account}"
}