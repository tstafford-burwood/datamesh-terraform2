#-----------------
# BIGQUERY MODULE
#-----------------

module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 5.2"

  // REQUIRED

  dataset_id = var.dataset_id
  project_id = var.project_id

  // OPTIONAL

  access                      = var.bigquery_access
  dataset_labels              = var.dataset_labels
  dataset_name                = var.dataset_name
  default_table_expiration_ms = var.default_table_expiration_ms
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  deletion_protection         = var.bigquery_deletion_protection
  description                 = var.bigquery_description
  encryption_key              = var.encryption_key
  external_tables             = var.external_tables
  location                    = var.location
  routines                    = var.routines
  tables                      = var.tables
  views                       = var.views
}