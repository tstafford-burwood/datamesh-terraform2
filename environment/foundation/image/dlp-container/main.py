# ------------------------------------------------------------
#  cloud-run-from-composer-demo\demo-service\main.py
# ------------------------------------------------------------

import os
from google.cloud import dlp_v2

from flask import Flask, request

import google.cloud.storage as storage

import logging as log
import google.cloud.logging as logging

info_types = ['PERSON_NAME', 'EMAIL_ADDRESS','STREET_ADDRESS', 
                   'LOCATION', 'PHONE_NUMBER']

# from werkzeug.routing import BaseConverter, ValidationError

# class PathVarArgsConverter(BaseConverter):
#     """Convert the remaining path segments to a list"""

#     def __init__(self, url_map):
#         super(PathVarArgsConverter, self).__init__(url_map)
#         self.regex = "(?:.*)"

#     def to_python(self, value):
#         return value.split(u"/")

#     def to_url(self, value):
#         return u"/".join(value)

    
logging_client = logging.Client()
logging_client.setup_logging()

app = Flask(__name__)


@app.route("/")
def index():
    return f"Hello, World!"


@app.route("/getDefaultFile/")
def get_default_file():
    log.info(f"Starting getDefaultFile()") 

    try:
        bucket_name = "my-graceful-castle-bucket"
        blob_name = "generated_workspace_file.json"
        contents = download_blob_into_memory(bucket_name, blob_name)
        name = os.environ.get("NAME", "World")
        log.info(f"Completed getDefaultFile()") 
        return f"Hello {name}! #4 - {contents}"

    except Exception as e:
        log.info(f"Exception thrown in getDefaultFile()") 
        log.error(e)
        return str(e)


@app.route("/getFileByName/")
def get_file_by_name():
    log.info(f"Starting get_file_by_name()") 

    try:
        bucket_name = request.args.get('b')
        blob_name = request.args.get('f')
        contents = download_blob_into_memory(bucket_name, blob_name)
        log.info(f"Completed get_file_by_name()")
        
        return f"get_file_by_name(gs://{bucket_name}/{blob_name}): {contents}"

    except Exception as e:
        log.info(f"Exception thrown in get_file_by_name()") 
        log.error(e)
        return str(e)


@app.route("/files/<path:varargs>") # /files/<bucket_name>/<object_prefix>")
def get_file_names(varargs=None): # args = <bucket_name>/<object_prefix>

    try:
        args = varargs.split("/")
        
        bucket_name = args[0]
        
        log.info(f"bucket_name: {bucket_name}")
        
        object_prefix = "/".join(args[1:])
        
        log.info(f"object_prefix: {object_prefix}")  
        
        file_names = get_gcs_object_names(bucket_name, object_prefix)
        
        log.info(f"type(file_names): {type(file_names)}")        
        log.info(f"file_names: {file_names}")  
        
        #filtered_names = [f.name for f in file_names]
        
        return f"{file_names}"
        
        # log.info(f"type(filtered_names): {type(filtered_names)}")        
        # log.info(f"filtered_names: {filtered_names}")
        
        #return f"/files/\r\nbucket_name: {bucket_name}\r\nobject_prefix: {object_prefix}\r\nfiltered_names: {filtered_names}\r\nfile_names: {file_names}"

    except Exception as e:
        log.info(f"Exception thrown in get_file_names()") 
        log.error(e)
        return str(e)

#@app.route("/dlp/<path:varargs>")
@app.route("/dlp")
def sample_create_dlp_job():
    # Create a client
    client = dlp_v2.DlpServiceClient()

    # Initialize request argument(s)
    request = dlp_v2.CreateDlpJobRequest(
        parent = "projects/prod-data-ops/locations/us-central1",
        inspect_job = {
            "storage_config": {
                "cloud_storage_options": {
                    "files_limit_percent": 100,
                    "file_set": {
                        "url": "gs://sde-us-central1-csv-165a/**"
                    },
                    "file_types": ["FILE_TYPE_UNSPECIFIED"]
                }
                },
            "inspect_config": {
                "info_types": [],
                "min_likelihood": "UNLIKELY",
                "custom_info_types": []
            },
            "inspect_template_name": "projects/prod-data-ops-fb4a/locations/us-central1/inspectTemplates/2071878167579768377",
            "actions": [
                {
                    "deidentify": {
                    "file_types_to_transform": [
                        "TEXT_FILE",
                        "IMAGE",
                        "CSV",
                        "TSV"
                    ],
                    "transformation_details_storage_config": {},
                    "transformation_config": {
                        "deidentify_template": "projects/prod-data-ops-fb4a/locations/us-central1/deidentifyTemplates/585522111742575514"
                    },
                    "cloud_storage_output": "gs://sde-us-central1-csv-deid-165a/deidentified/"
                    }
                }
                ],
                    }
                )
    # Make the request
    response = client.create_dlp_job(request=request)

    # Handle the response
    print(response)


if __name__ == "__main__":    
    # app.url_map.converters['varargs'] = PathVarArgsConverter
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))



def download_blob_into_memory(bucket_name, blob_name):
    """Downloads a blob into memory."""
    # The ID of your GCS bucket
    # bucket_name = "your-bucket-name"

    # The ID of your GCS object
    # blob_name = "storage-object-name"

    try:
        storage_client = storage.Client()

        bucket = storage_client.bucket(bucket_name)

        # Construct a client side representation of a blob.
        # Note `Bucket.blob` differs from `Bucket.get_blob` as it doesn't retrieve
        # any content from Google Cloud Storage. As we don't need additional data,
        # using `Bucket.blob` is preferred here.
        blob = bucket.blob(blob_name)
        contents = blob.download_as_string() # TODO: download_as_string() is deprecated. Use download_as_bytes(...) instead

        return contents

    except Exception as e:
        # print(e)
        return f"Error in download_blob_into_memboer(...): {str(e)}"


def get_gcs_object_names(bucket_name, object_prefix):

    try:
        storage_client = storage.Client()
        
        # storage_client.list_blobs(bucket_name)
        # bucket = storage_client.bucket(bucket_name)

        bucket = storage.Bucket(storage_client, bucket_name)
        all_blobs = list(storage_client.list_blobs(bucket, prefix=object_prefix))

        return all_blobs

    except Exception as e:
        # print(e)
        return f"Error in get_gcs_object_names(...): {str(e)}"