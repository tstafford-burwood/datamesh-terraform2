# WELCOME TO YOUR SECURE DATA ENCLAVE!

To get started, all of your data will be located in a Data Lake called: ${DATALAKE_PROJECT_ID},
which has a bucket called ${DATALAKE_BUCKET}.

<i>Note: You will not be able to upload or delete from this storage bucket, only copy from it.</i>

## Getting started

### Create a new local user
1. Login as sudo user and open a command prompt.
1. Create a new user and to the xRDP group:
    ```bash
    sudo adduser foo
    sudo usermod -G xrdp foo
    ``
1. Reboot for the new changes

### Mount GCS buckets
Here we want to mount the two GCS buckets from the data-lake and from the local research workspace.

1. Login as sudo user and open a command prompt.
1. Create 2 new directories and update permissions so all users have access
    ```bash
    sudo mkdir /research-data
    sudo mkdir /data-lake
    sudo chmod -R 757 /research-data
    sudo chmod -R 757 /data-lake
    ```
1. Add entries to fstab by typing `sudo nano /etc/fstab`
    ```bash
    ${DATALAKE_BUCKET} /data-lake gcsfuse rw,allow_other,file_mode=777,dir_mode=777,implicit_dirs,_netdev
    ${SHARED_BUCKET} /research-data gcsfuse rw,allow_other,file_mode=777,dir_mode=777,implicit_dirs,_netdev
    ```
1. Save the entries.

To launch your Jupyter Lab instance running the following from a command line window:
```bash
jupyter-lab
```

## FUN Commands!
### List contents
List all of the contents in the bucket by running the following:

```bash
gsutil ls gs://${DATALAKE_BUCKET}'
```

## Copy Everything

To copy everything from the data lake bucket to your local workstation:

```bash
gsutil -m cp -r gs://${DATALAKE_BUCKET} .
```

### Copy Everything from a folder

To copy everything from a single folder from the data lake bucket to your local workstation:

```bash
gsutil -m cp -r gs://${DATALAKE_BUCKET}/<folder> .
```

### To Share Files outside of the ENCLAVE

```bash
gsutil cp /path/to/file gs://${SHARED_BUCKET}/EGRESS
```