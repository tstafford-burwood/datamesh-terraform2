resource "google_storage_bucket_object" "dag" {
  # Upload DAG to the data-ops cloud composer DAG bucket
  bucket = trimprefix(local.dag_bucket, "gs://")
  name   = "dags/${var.prefix}_${local.researcher_workspace_name}_workspace_dag.py"
  source = local_file.workspace_dag_py.filename
}

resource "local_file" "workspace_dag_py" {
  filename = "${path.module}/scripts/${var.prefix}_${local.researcher_workspace_name}_workspace_dag.py"
  content = templatefile("${path.module}/scripts/workspace_dag.py.tpl", {
    RESEARCHER_WORKSPACE_NAME = lower(replace(local.researcher_workspace_name, "-", "_"))
    RESEARCHER_BUCKET         = module.gcs_bucket_shared.name
    DATAOPS_PROJECT_ID        = local.staging_project_id
    DATAOPS_CORDON_BUCKET     = lookup(local.data_ops_bucket, local.researcher_workspace_name, "")
    REGION                    = local.region
    DATA_STEWARDS             = local.steward_emails
    APP_INTG_TRIGGER_APPROVAL = local.pubsub_appint_approval
  })
}

# ---
# Delete Dag Template

resource "google_storage_bucket_object" "dataops_delete_dag" {
  # Upload DAG to the data-ops cloud composer DAG bucket.
  bucket = trimprefix(local.dag_bucket, "gs://")
  name   = "dags/${var.prefix}_${local.researcher_workspace_name}_dataops_delete.py"
  source = local_file.dataops_delete_dag_py.filename
}

resource "local_file" "dataops_delete_dag_py" {
  filename = "${path.module}/scripts/${var.prefix}_${local.researcher_workspace_name}_dataops_delete.py"
  content = templatefile("${path.module}/scripts/DataOps_Delete_DAG.py.tpl", {
    RESEARCHER_WORKSPACE_NAME = lower(replace(local.researcher_workspace_name, "-", "_"))
    DATAOPS_BUCKET            = lookup(local.data_ops_bucket, local.researcher_workspace_name, "") # lookup the dataops bucket name
    DATA_STEWARDS             = local.steward_emails
    DATAOPS_PROJECT_ID        = local.staging_project_id
    APP_INTG_TRIGGER_RESULTS  = local.pubsub_appint_results
  })
}