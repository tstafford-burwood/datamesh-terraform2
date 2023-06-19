"""
${RESEARCHER_WORKSPACE_NAME}_DataOps_to_Egress_DAG
"""

#  Workflow Summary
# ================================================================================
#  1. Move all files from the Staging project's ingress bucket to the 
#     Workspace project's ingress bucket
#     - All files will be copied to a time-stamped folder to avoid overwriting 
#       existing files of the same name.


#  Notes for ops support
# ================================================================================
#  Guide to troubleshooting DAGs: https://cloud.google.com/composer/docs/how-to/using/troubleshooting-dags#troubleshooting_workflow


#  Google Cloud resource dependencies
# ================================================================================
#  Resource Managemer
#  1. SDE folder
#    - Policies & Permissions
#  
#  2. Staging project
#     - Cloud Composer
#     - GCS bucket
#       - Ingress bucket
#  3. Researcher workspace project
#     - GCS bucket
#       - Ingress bucket

from airflow import models
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator
from airflow.providers.google.cloud.operators.pubsub import PubSubPublishMessageOperator
from airflow.utils.dates import days_ago

# ============================================================
#  Data Ops project
# ============================================================

SRCE_BUCKET="${DATAOPS_BUCKET}"

# ============================================================
#  Egress project
# ============================================================

DEST_BUCKET="${EGRESS_BUCKET}"

# ============================================================
#  Pub/Sub Message
# ============================================================


m1 = {'data': b'Results!',
              'attributes': {'initiative': '${RESEARCHER_WORKSPACE_NAME}',
                             'email': '${DATA_STEWARDS}',
                             'message': 'Files have been successfully transfered for research iniative: <b>${RESEARCHER_WORKSPACE_NAME}</b>.<br>Click <a href="https://console.cloud.google.com/storage/browser/${EGRESS_BUCKET}/">here</a> to view the egress bucket (if applicable).'}
}

# ============================================================
#  DAG
# ============================================================

DAG_ID="${RESEARCHER_WORKSPACE_NAME}_DataOps_to_Egress_DAG"

with models.DAG(
    dag_id=DAG_ID,
    description="Move files from one bucket to another",
    schedule_interval=None,  # This DAG must be triggered manually
    start_date=days_ago(1),
    catchup=False,
    tags=['gcs', 'researcher', 'egress', 'share','${RESEARCHER_WORKSPACE_NAME}']
) as dag:

    # ================================================================================
    #  Task: move_files_task
    # ================================================================================

    move_files_task = GCSToGCSOperator(
        task_id="move_files",
        source_bucket=SRCE_BUCKET,
        source_object="${RESEARCHER_WORKSPACE_NAME}/*",
        destination_bucket=DEST_BUCKET,
        destination_object="{{ run_id | replace('scheduled__', '') | replace('manual__', '') | replace('_00:00', '') | replace('+', '_')}}/",
        move_object=True,
        replace=False
    )
    
    # ================================================================================
    #  Task: Pub/Sub
    # ================================================================================
    
    push_to_pubsub = PubSubPublishMessageOperator(
        task_id='push_to_pubsub_task',
        project_id="${PROJECT_ID}",
        topic="${PUBSUB_APPINTG_TOPIC}",
        messages=[m1],
        )
    
    move_files_task >> push_to_pubsub