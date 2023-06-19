# Terraform module for Data Ingress

This repository provides an opinionated way to deploy multiple GCS bucket per researcher initiative to ingest data.

## Reference Architecture

![](../../../docs/data-ingress.png)

This modules goal is to loop through all the [researcher sub-folders](../folders/variables.tf#L1) and create a GCS bucket per researcher workspace.


The resources that this module will create are:

### GCS Bucket
* A new GCS bucket is created per researcher initiative. This is based off of the subfolder value located [here](../folders/variables.tf#L1).
    - `"gcs-{region}-{researcher}-{random_id}`

### IAM Roles
* Project level admins that are defined in the constants.tf
    - "roles/compute.admin"
    - "roles/compute.networkAdmin"
    - "roles/compute.osAdminLogin"
    - "roles/compute.securityAdmin"
    - "roles/iam.serviceAccountAdmin"
    - "roles/iap.tunnelResourceAccessor"

### VPC
* One VPC:
    - Name:
    - default deployment in `us-central1`
    - Private access is enabled
    - CIDR `172.16.0.0/24`



<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [main.tf](./main.tf) | Module-level locals and resources. | <code>constants</code> · <code>google</code> · <code>project_iam</code> · <code>project_iam_custom_role</code> | <code>google_logging_project_bucket_config</code> · <code>google_storage_bucket</code> · <code>random_id</code> |
| [org-pol.tf](./org-pol.tf) | None | <code>google</code> | <code>time_sleep</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [providers.tf](./providers.tf) | Provider configurations. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [enforce](variables.tf#L23) | Whether this policy is enforced. | <code>bool</code> |  | <code>true</code> |  |
| [gcs_bucket](variables.tf#L17) | List of bucket names to create. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#34;ingress-example-here&#34;&#93;</code> |  |
| [project_iam_admin_roles](variables.tf#L1) | List of roles to assign to admins | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;viewer&#34;,              &#35; Grants permissions to list buckets in the project&#10;  &#34;roles&#47;storage.objectAdmin&#34;, &#35; Grants full control of objects, including listing, creating, viewing, and deleting objects&#10;&#93;">&#91;&#8230;&#93;</code> |  |
| [subnet_cidr](variables.tf#L11) | Subnet CIDR range | <code>string</code> |  | <code>&#34;172.16.0.0&#47;24&#34;</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [bucket_list_custom_role_name](outputs.tf#L22) | Output of the custom role name |  |  |
| [bucket_names](outputs.tf#L16) | Bucket names. |  |  |
| [project_id](outputs.tf#L1) | Project ID |  |  |
| [project_name](outputs.tf#L11) | Project Name |  |  |
| [project_number](outputs.tf#L6) | Project Number |  |  |

<!-- END TFDOC -->
