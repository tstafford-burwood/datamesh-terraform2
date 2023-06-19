#!/usr/bin/env bash
set -eo pipefail

# Create mount directory for service
mkdir -p my-bucket
mkdir -p data-lake

echo "Mounting GCS Fuse."
gcsfuse --debug_gcs --debug_fuse ${SHARED_BUCKET} my-bucket
gcsfuse --debug_gcs --debug_fuse ${DATALAKE_BUCKET} data-lake
echo "Mounting completed."