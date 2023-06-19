#-----------------------
# SERVICE ACCOUNT MODULE
#-----------------------

module "service_account" {

  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  // REQUIRED

  project_id = var.project_id

  // OPTIONAL

  billing_account_id = var.billing_account_id
  description        = var.description
  display_name       = var.display_name
  generate_keys      = var.generate_keys
  grant_billing_role = var.grant_billing_role
  grant_xpn_roles    = var.grant_xpn_roles
  names              = var.service_account_names
  org_id             = var.org_id
  prefix             = var.prefix
  project_roles      = var.project_roles
}