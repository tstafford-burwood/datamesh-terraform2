resource "google_storage_bucket_object" "dag" {
  # Upload DAG to the data-ops cloud composer DAG bucket
  bucket = trimprefix(local.dag_bucket, "gs://")
  name   = "dags/${var.prefix}_${local.researcher_workspace_name}_dataops_to_egress_dag.py"
  source = local_file.dataops_to_egress_dag_py.filename
}

resource "local_file" "dataops_to_egress_dag_py" {
  filename = "./scripts/${var.prefix}_${local.researcher_workspace_name}_dataops_to_egress_dag.py"
  content = templatefile("${path.module}/scripts/DataOps_to_EgressPrj_DAG.py.tpl", {
    RESEARCHER_WORKSPACE_NAME = lower(replace(local.researcher_workspace_name, "-", "_"))
    DATAOPS_BUCKET            = lookup(local.data_ops_bucket, local.researcher_workspace_name, "") # lookup the dataops bucket name
    EGRESS_BUCKET             = module.gcs_bucket_researcher_data_egress.name                      # single bucket name output
    PROJECT_ID                = local.staging_project_id
    PUBSUB_APPINTG_TOPIC      = local.pubsub_appint_results
    DATA_STEWARDS             = local.steward_emails
  })
}