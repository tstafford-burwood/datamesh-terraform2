"""
${RESEARCHER_WORKSPACE_NAME}_DataIngress_to_DataLake_DAG
"""

#  Workflow Summary
# ================================================================================
#  1. Move all files from the ingress bucket to the corresponding Data Lake bucket
#     - All files will be copied to a time-stamped folder to avoid overwriting 
#       existing files of the same name.


#  Notes for ops support
# ================================================================================
#  Guide to troubleshooting DAGs: https://cloud.google.com/composer/docs/how-to/using/troubleshooting-dags#troubleshooting_workflow


from airflow import models
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator
from airflow.utils.dates import days_ago

# ============================================================
#  Data Ingress buckets
# ============================================================

INGRESS_BUCKET="${INGRESS_BUCKET}"

# ============================================================
#  Data Lake bucket
# ============================================================

DATALAKE_BUCKET="${DATALAKE_BUCKET}"

# ============================================================
#  DAG
# ============================================================

DAG_ID="${RESEARCHER_WORKSPACE_NAME}_DataIngress_to_DataLake"

with models.DAG(
    dag_id=DAG_ID,
    description="Move files from one bucket to another",
    schedule_interval='*/5 * * * *',  # This DAG runs 5min
    start_date=days_ago(1),
    catchup=False,
    tags=['gcs', 'ingress', 'data-lake', 'transfer', '${RESEARCHER_WORKSPACE_NAME}']
) as dag:

    # ================================================================================
    #  Task: move_files_task
    # ================================================================================

    move_prj_x_files_task = GCSToGCSOperator(
        task_id="move_files",
        source_bucket=INGRESS_BUCKET,
        source_object="*",
        destination_bucket=DATALAKE_BUCKET,
        destination_object="{{ run_id | replace('scheduled__', '') | replace('manual__', '') | replace('_00:00', '') | replace('+', '_')}}/",
        move_object=True,
        replace=False
    )
    
    move_prj_x_files_task