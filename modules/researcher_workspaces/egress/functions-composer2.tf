data "archive_file" "cp2_cf_egress_module_zip" {
  count       = startswith(local.composer_version, "composer-2") ? 1 : 0
  output_path = "${path.module}/egress_build_fn.zip"
  type        = "zip"
  source_dir  = "${path.module}/functions/composer2/egress"

  depends_on = [
    local_file.cp2_cf_egress_main_py[0]
  ]
}

resource "google_storage_bucket_object" "cp2_cf_egress_module_zip" {
  count        = startswith(local.composer_version, "composer-2") ? 1 : 0
  bucket       = google_storage_bucket.function_archive_storage.name
  name         = "cf_egress_module.zip"
  content_type = "application/zip"
  source       = data.archive_file.cp2_cf_egress_module_zip[count.index].output_path
}

resource "local_file" "cp2_cf_egress_main_py" {
  # Create the template file separately from the archive_file block
  count    = startswith(local.composer_version, "composer-2") ? 1 : 0 # Composer-2 does not require CLIENT_ID
  filename = "${path.module}/functions/composer2/egress/main.py"
  content = templatefile("${path.module}/functions/composer2/main.py.tpl", {

    # `DataOps_to_EgressPrj_DAG` is found in the ./scripts/*.tpl file
    DAG_NAME    = format("%s_%s", lower(replace(local.researcher_workspace_name, "-", "_")), "DataOps_to_Egress_DAG")
    AIRFLOW_URI = local.composer_ariflow_uri
  })

}

resource "google_cloudfunctions_function" "cp2_egress" {
  count                 = startswith(local.composer_version, "composer-2") ? 1 : 0
  project               = local.staging_project_id
  name                  = format("%s-%s", "cf", trimprefix(trim(local_file.dataops_to_egress_dag_py.filename, ".py"), "/scripts/"))
  runtime               = "python310"
  description           = format("Research initiative: %s", lower(replace(local.researcher_workspace_name, "-", "_")))
  available_memory_mb   = 256
  entry_point           = "http_trigger"
  region                = var.region
  timeout               = 60
  min_instances         = 0
  max_instances         = 10
  service_account_email = local.composer_sa

  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"

  # Use the Serveless VPC Connector in the Data Ops project
  ingress_settings              = "ALLOW_ALL"
  vpc_connector                 = local.vpc_connector
  vpc_connector_egress_settings = "ALL_TRAFFIC"

  source_archive_bucket = google_storage_bucket.function_archive_storage.name
  source_archive_object = google_storage_bucket_object.cp2_cf_egress_module_zip[count.index].name

}

# 3-9-23: Need to comment back in. For now, leaving out to remove the blocker.
# Had issues deploying Application Integration
# resource "google_cloudfunctions_function_iam_member" "cp2_invoker" {
#   # IAM entry for Application Integration SA found in Data Ops project
#   count          = startswith(local.composer_version, "composer-2") ? 1 : 0
#   project        = local.staging_project_id
#   region         = var.region
#   cloud_function = google_cloudfunctions_function.cp2_egress[count.index].name

#   role   = "roles/cloudfunctions.invoker"
#   member = "serviceAccount:service-${local.staging_project_number}@gcp-sa-integrations.iam.gserviceaccount.com"
# }

# Delete Module

resource "local_file" "cp2_cf_delete_main_py" {
  # Create the template file separately from the archive_file block
  count    = startswith(local.composer_version, "composer-2") ? 1 : 0 # Composer-2 does not require CLIENT_ID
  filename = "${path.module}/functions/composer2/delete/main.py"
  content = templatefile("${path.module}/functions/composer2/main.py.tpl", {

    # `deletePrj_DAG` is found in the ../../env/foundation/data-ops/cloud-composer/*.tpl file
    DAG_NAME    = format("%s_%s", lower(replace(local.researcher_workspace_name, "-", "_")), "DataOps_Delete_DAG")
    AIRFLOW_URI = local.composer_ariflow_uri
  })

}

data "archive_file" "cp2_cf_delete_module_zip" {
  count       = startswith(local.composer_version, "composer-2") ? 1 : 0
  output_path = "${path.module}/delete_build_fn.zip"
  type        = "zip"
  source_dir  = "${path.module}/functions/composer2/delete"

  depends_on = [
    local_file.cp2_cf_delete_main_py[0]
  ]
}

resource "google_storage_bucket_object" "cp2_cf_delete_module_zip" {
  count        = startswith(local.composer_version, "composer-2") ? 1 : 0
  bucket       = google_storage_bucket.function_archive_storage.name
  name         = "cf_delete_module.zip"
  content_type = "application/zip"
  source       = data.archive_file.cp2_cf_delete_module_zip[count.index].output_path
}

resource "google_cloudfunctions_function" "cp2_delete" {
  count                 = startswith(local.composer_version, "composer-2") ? 1 : 0
  project               = local.staging_project_id
  name                  = format("%s-%s-%s-%s", "cf", var.prefix, local.researcher_workspace_name, "delete-dag")
  runtime               = "python310"
  description           = format("Research initiative: %s", lower(replace(local.researcher_workspace_name, "-", "_")))
  available_memory_mb   = 256
  entry_point           = "http_trigger"
  region                = var.region
  timeout               = 60
  min_instances         = 0
  max_instances         = 10
  service_account_email = local.composer_sa

  # Use the Serveless VPC Connector in the Data Ops project
  ingress_settings              = "ALLOW_ALL"
  vpc_connector                 = local.vpc_connector
  vpc_connector_egress_settings = "ALL_TRAFFIC"

  source_archive_bucket = google_storage_bucket.function_archive_storage.name
  source_archive_object = google_storage_bucket_object.cp2_cf_delete_module_zip[count.index].name

  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"

}

# 3-9-23: Need to comment back in. For now, leaving out to remove the blocker.
# Had issues deploying Application Integration
# resource "google_cloudfunctions_function_iam_member" "cp2_invoker_delete" {
#   # IAM entry for Application Integration SA found in Data Ops project
#   count          = startswith(local.composer_version, "composer-2") ? 1 : 0
#   project        = local.staging_project_id
#   region         = var.region
#   cloud_function = google_cloudfunctions_function.cp2_delete[count.index].name

#   role   = "roles/cloudfunctions.invoker"
#   member = "serviceAccount:service-${local.staging_project_number}@gcp-sa-integrations.iam.gserviceaccount.com"
# }