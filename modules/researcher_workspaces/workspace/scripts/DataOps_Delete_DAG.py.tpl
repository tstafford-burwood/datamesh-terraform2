"""
${RESEARCHER_WORKSPACE_NAME}_DataOps_Delete_DAG
"""

#  Workflow Summary
# ================================================================================
#  1. Delete all the objects in the bucket path
#       - Additional paths can be added manually


#  Notes for ops support
# ================================================================================
#  Guide to troubleshooting DAGs: https://cloud.google.com/composer/docs/how-to/using/troubleshooting-dags#troubleshooting_workflow


from airflow import models
from airflow.operators import bash_operator
from airflow.providers.google.cloud.operators.pubsub import PubSubPublishMessageOperator
from airflow.utils.dates import days_ago

# ============================================================
#  Data Ops project
# ============================================================

SRCE_BUCKET="${DATAOPS_BUCKET}"

m1 = {'data': b'File Deleted!',
              'attributes': {'initiative': '${RESEARCHER_WORKSPACE_NAME}',
                             'email': '${DATA_STEWARDS}',
                             'message': 'All files have been successfully removed from the <b>${RESEARCHER_WORKSPACE_NAME}</b> initiative.<br>Click <a href="https://console.cloud.google.com/storage/browser/${DATAOPS_BUCKET}/">here</a> to view the ${RESEARCHER_WORKSPACE_NAME} bucket.'}
}

# ============================================================
# DELETE Ojbects
# ============================================================

delete_objects = """
SRCE_BUCKET="{{ params.SRCE_BUCKET }}"

gsutil -m rm -r gs://$SRCE_BUCKET/${RESEARCHER_WORKSPACE_NAME}/**

"""

# ============================================================
#  DAG
# ============================================================

DAG_ID="${RESEARCHER_WORKSPACE_NAME}_DataOps_Delete_DAG"

with models.DAG(
    dag_id=DAG_ID,
    description="Move files from one bucket to another",
    schedule_interval=None,  # This DAG must be triggered manually
    start_date=days_ago(1),
    catchup=False,
    tags=['gcs', 'dataops', 'delete', '${RESEARCHER_WORKSPACE_NAME}']
) as dag:

    # ================================================================================
    #  Task: delete_files_task
    # ================================================================================

    delete_prj_x_files_task = bash_operator.BashOperator(
        task_id="delete_prj_x_files",
        bash_command=delete_objects,
        append_env=True,
        params={
            'SRCE_BUCKET': SRCE_BUCKET
        },
    )

    # ================================================================================
    #  Task: Pub/Sub
    # ================================================================================
    
    push_to_pubsub = PubSubPublishMessageOperator(
        task_id='push_to_pubsub_task',
        project_id='${DATAOPS_PROJECT_ID}',
        topic='${APP_INTG_TRIGGER_RESULTS}',
        messages=[m1],
        )
    
    delete_prj_x_files_task >> push_to_pubsub