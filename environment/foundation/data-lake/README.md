# Terraform Directory for Data Lake Module

This repository provides an opinionated way to deploy multiple GCS buckets per researcher initiative.

## Reference Architecture
![](../../../docs/data-lake-resources.png)

This modules goal is to loop through all the [researcher sub-folders](../folders/variables.tf#L1) and create a GCS bucket per researcher workspace.


The resources that this module will create are:

### GCS Bucket
* A new GCS bucket is created per researcher initiative. This is based off of the subfolder value located [here](../folders/variables.tf#L1).
    - `"gcs-{region}-{researcher}-{random_id}`


### IAM Roles
* Project level admins that are defined in the [constants.tf](../constants/constants.tf#L18)
    - "roles/storage.admin"
    - "roles/bigquery.admin"
* Project level users that are defined in the [constants.tf](../constants/constants.tf#L19)
    - "roles/browser", # Read access to browse hiearchy for the project
    - "roles/storage.objectViewer"
    - "roles/bigquery.dataViewer"
    - "roles/bigquery.filteredDataViewer"
    - "roles/bigquery.metadataViewer"
    - "roles/bigquery.resourceViewer"

### IAM Custom Role Deployed

* `Custom SDE Role for Data Lake Storage Ops`
    * storage.buckets.list
    * storage.objects.get
    * storage.objects.list


<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [buckets.tf](./buckets.tf) | None |  | <code>google_storage_bucket</code> · <code>random_id</code> |
| [iam.tf](./iam.tf) | None | <code>project_iam</code> · <code>project_iam_custom_role</code> |  |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>constants</code> · <code>google</code> | <code>google_logging_project_bucket_config</code> |
| [org-pol.tf](./org-pol.tf) | None | <code>google</code> | <code>time_sleep</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [enforce](variables.tf#L5) | Whether this policy is enforce. | <code>bool</code> |  | <code>true</code> |  |
| [force_destroy](variables.tf#L53) | To allow terraform to destroy the bucket even if there are objects in it. | <code>bool</code> |  | <code>true</code> |  |
| [project_iam_admins_list](variables.tf#L15) | The IAM role(s) to assign to the member at the defined project. | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;storage.admin&#34;,&#10;  &#34;roles&#47;bigquery.admin&#34;,&#10;&#93;">&#91;&#8230;&#93;</code> |  |
| [stewards_project_iam_roles](variables.tf#L25) | The IAM role(s) to assign to the member at the defined project. | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;browser&#34;, &#35; Read access to browse hiearchy for the project&#10;  &#34;roles&#47;storage.objectViewer&#34;,&#10;  &#34;roles&#47;bigquery.dataViewer&#34;,&#10;  &#34;roles&#47;bigquery.filteredDataViewer&#34;,&#10;  &#34;roles&#47;bigquery.metadataViewer&#34;,&#10;  &#34;roles&#47;bigquery.resourceViewer&#34;,&#10;&#93;">&#91;&#8230;&#93;</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [bucket_list_custom_role_name](outputs.tf#L29) | Output of the custom role name |  |  |
| [data_lake_project_id](outputs.tf#L5) | The project id |  |  |
| [data_lake_project_name](outputs.tf#L11) | The project name |  |  |
| [data_lake_project_number](outputs.tf#L17) | The project number. |  |  |
| [research_to_bucket](outputs.tf#L23) | Map of researcher name to their bucket name |  |  |

<!-- END TFDOC -->
