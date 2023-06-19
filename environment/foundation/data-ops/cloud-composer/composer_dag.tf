resource "google_storage_bucket_object" "dataingress_to_datalake_dag" {
  # Upload DAG to the data-ops cloud composer DAG bucket.
  for_each = toset(local.research_wrkspc)

  bucket = trimprefix(trimsuffix(module.cloud_composer.gcs_bucket, "/dags"), "gs://")
  name   = "dags/${each.value}_ingress_to_datalake.py"
  source = local_file.dataingress_to_datalake_dag_py[each.value].filename
}

resource "local_file" "dataingress_to_datalake_dag_py" {
  # Each researcher initiative (IE: Project-X, Rare-Disease, Project-Y) will have their own buckets in the ingress and 
  # datalake projects. To help map these buckets, we're using the reseracher workspace folder IDs as flags to identify
  # these maps.
  # IE: Research initiative Project-X will have a folder ID called Project-X and will have a bucket in 
  # ingress and datalake called: `gcs-us-central1-project-x`. Use the id `project-x` as the unique identify.

  for_each = toset(local.research_wrkspc) # loop through all research initiatives

  filename = "${path.module}/scripts/${each.value}_ingress_to_datalake.py"
  content = templatefile("${path.module}/scripts/1_DataIngress_to_DataLake_DAG.py.tpl", {
    RESEARCHER_WORKSPACE_NAME = lower(replace(each.value, "-", "_"))
    INGRESS_BUCKET            = lookup(local.ingress_buckets, each.value, "")  # lookup the ingress bucket name that matches the researcher
    DATALAKE_BUCKET           = lookup(local.datalake_buckets, each.value, "") # lookup the datalake bucket name that matches the researcher
  })
}

# ---

# resource "google_storage_bucket_object" "dataops_delete_dag" {
#   # Upload DAG to the data-ops cloud composer DAG bucket.
#   for_each = toset(local.research_wrkspc)

#   bucket = trimprefix(trimsuffix(module.cloud_composer.gcs_bucket, "/dags"), "gs://")
#   name   = "dags/${each.value}_dataops_delete.py"
#   source = local_file.dataops_delete_dag_py[each.value].filename
# }

# resource "local_file" "dataops_delete_dag_py" {
#   # Each researcher initiative (IE: Project-X, Rare-Disease, Project-Y) will have their own buckets in the ingress and 
#   # datalake projects. To help map these buckets, we're using the reseracher workspace folder IDs as flags to identify
#   # these maps.
#   # IE: Research initiative Project-X will have a folder ID called Project-X and will have a bucket in 
#   # ingress and datalake called: `gcs-us-central1-project-x`. Use the id `project-x` as the unique identify.

#   for_each = toset(local.research_wrkspc) # loop through all research initiatives

#   filename = "${path.module}/scripts/${each.value}_dataops_delete.py"
#   content = templatefile("${path.module}/scripts/4_DataOps_Delete_DAG.py.tpl", {
#     RESEARCHER_WORKSPACE_NAME = lower(replace(each.value, "-", "_"))
#     DATAOPS_BUCKET            = local.dataops_bucket[0] # lookup the dataops bucket name
#   })
# }

