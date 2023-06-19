# Terraform Directory for Data Operations (Data-Ops) Module

This repository provides an opinionated wayt to deploy a data-ops project that hosts Cloud Composer (Airflow) which helps orchestrate data movement between projects.

## Reference Architecture

![](../../../docs/data-ops.png)

This module is used to deploy infrastructure for Data-Ops. It deploys a private cloud composer environment with the necessary service account. A private cloud composer environment has no external access to the public internet. It uses the GCP org policy, Domain sharing delegation, to limit the accounts that can access the web interface.

A single service account, `{env}-composer-sa` is used as the service account with elevated permissions to move data around. In this instance, that service account is provisioned in this project, but the IAM roles are applied at the folder level.

### Service Accounts Created
- Composer Service Account: `{env}-composer-sa`

### IAM Roles Deployed
* Admins
    - "roles/bigquery.admin",        # Full access to BigQuery
    - "roles/storage.objectViewer",  # View objects in buckets
    - "roles/storage.objectCreator", # Create objects, but not delete or - overwrite objects
    - "roles/composer.admin",        # Full access to Cloud Composer
    - "roles/composer.environmentAndStorageObjectAdmin",
    - "roles/run.admin",        # Full access to Cloud Run
    - "roles/monitoring.admin", # Full access to monitoring, used by Cloud Composer
    - "roles/notebooks.admin",  # Start/stop and create notebooks
    - "roles/logging.admin",    # Full access to Logging

* Stewards
    - "roles/bigquery.user",           # Run jobs
    - "roles/bigquery.dataViewer",     # Can enumerate all datasets in the project
    - "roles/storage.objectViewer",    # View objects in buckets
    - "roles/storage.objectCreator",   # Create objects, but not delete or overwrite objects
    - "roles/container.clusterViewer", # Provides access to get and list GKE clusters - used to view Composer Environemtn
    - "roles/composer.user",
    - "roles/composer.environmentAndStorageObjectViewer",
    - "roles/monitoring.viewer", # read-only access to get and list info about all monitoring data
    - "roles/notebooks.viewer",
    - "roles/bigquery.admin",
    - "roles/logging.viewer", # see longs from within Cloud Composer
    - "roles/dlp.admin"
    

* Composer Service Account @ the folder level
    - "roles/composer.worker",
    - "roles/iam.serviceAccountUser",
    - "roles/bigquery.dataOwner",
    - "roles/dlp.jobsEditor",
    - "roles/storage.objectAdmin",
    - "roles/bigquery.jobUser"

### VPC
* One VPC:
    - Name: `data-ops-us-central1-subnet-01`
    - default deployment in `us-central`
    - Private access is eanbled
    - CIDR `10.0.0.0/16`

### Buckets Created
* One GCS Bucket:
    * `cordon`

### Cloud DNS
* The project will be placed inside of a VPC Serivce perimeter and multiple Cloud DNS entries must be created so the different services can reach the restricted Google APIs list.


<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [buckets.tf](./buckets.tf) | None | <code>google</code> | <code>google_storage_bucket</code> · <code>random_id</code> |
| [cloud_dns.tf](./cloud_dns.tf) | None | <code>cloud_dns</code> |  |
| [dlp.tf](./dlp.tf) | None |  | <code>google_data_loss_prevention_deidentify_template</code> · <code>google_data_loss_prevention_inspect_template</code> |
| [iam.tf](./iam.tf) | None | <code>project_iam</code> · <code>project_iam_custom_role</code> | <code>google_artifact_registry_repository_iam_member</code> · <code>google_project_iam_member</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>constants</code> · <code>google</code> | <code>google_logging_project_bucket_config</code> · <code>google_vpc_access_connector</code> |
| [org-pol.tf](./org-pol.tf) | None |  | <code>google_project_organization_policy</code> · <code>time_sleep</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [pubsub.tf](./pubsub.tf) | None | <code>google</code> |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [data_ops_admin_project_iam_roles](variables.tf#L5) | The IAM role(s) to assign to the `Admins` at the defined project. | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;bigquery.admin&#34;,        &#35; Full access to BigQuery&#10;  &#34;roles&#47;storage.objectViewer&#34;,  &#35; View objects in buckets&#10;  &#34;roles&#47;storage.objectCreator&#34;, &#35; Create objects, but not delete or overwrite objects&#10;  &#34;roles&#47;composer.admin&#34;,        &#35; Full access to Cloud Composer&#10;  &#34;roles&#47;composer.environmentAndStorageObjectAdmin&#34;,&#10;  &#34;roles&#47;run.admin&#34;,        &#35; Full access to Cloud Run&#10;  &#34;roles&#47;monitoring.admin&#34;, &#35; Full access to monitoring, used by Cloud Composer&#10;  &#34;roles&#47;notebooks.admin&#34;,  &#35; Start&#47;stop and create notebooks&#10;  &#34;roles&#47;logging.admin&#34;,    &#35; Full access to Logging&#10;  &#34;roles&#47;integrations.integrationAdmin&#34;,&#10;&#10;&#10;&#93;">&#91;&#8230;&#93;</code> |  |
| [dlp_service_agent_iam_role_list](variables.tf#L48) | The IAM role(s) to assign to the member at the defined folder. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#34;roles&#47;dlp.jobsEditor&#34;, &#34;roles&#47;dlp.user&#34;, &#93;</code> |  |
| [enforce](variables.tf#L81) | Whether this policy is enforce. | <code>bool</code> |  | <code>true</code> |  |
| [srde_project_domain_restricted_sharing_allow](variables.tf#L69) | List one or more Cloud Identity or Google Workspace custom IDs whose principals can be added to IAM policies. Leave empty to not enable. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [srde_project_resource_location_restriction_allow](variables.tf#L75) | This list constraint defines the set of locations where location-based GCP resources can be created. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#34;in:us-locations&#34;&#93;</code> |  |
| [srde_project_vms_allowed_external_ip](variables.tf#L63) | This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [csv_buckets_map](outputs.tf#L84) | Bucket resoures by name |  |  |
| [csv_names_list](outputs.tf#L89) | List of bucket names |  |  |
| [custom_role_id](outputs.tf#L55) | The role_id name. |  |  |
| [custom_role_name](outputs.tf#L50) | The name of the role in the format projects/{{project}}/roles/{{role_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings. |  |  |
| [dlp_deid_id](outputs.tf#L77) | The resource name of the de-id template. |  |  |
| [dlp_deid_name](outputs.tf#L72) | The resource name of the de-id template. |  |  |
| [dlp_inspect_id](outputs.tf#L67) | An identifier for the inspect template. |  |  |
| [dlp_inspect_name](outputs.tf#L62) | The resource name of the inspect template. |  |  |
| [network_name](outputs.tf#L18) | The name of the VPC being created |  |  |
| [research_to_bucket](outputs.tf#L95) | Map of researcher name to their bucket name |  |  |
| [staging_project_id](outputs.tf#L1) | Project ID |  |  |
| [staging_project_name](outputs.tf#L7) | Project Name |  |  |
| [staging_project_number](outputs.tf#L12) | Project Number |  |  |
| [subnets_names](outputs.tf#L23) | The names of the subnets being created |  |  |
| [subnets_regions](outputs.tf#L33) | The region where the subnets will be created. |  |  |
| [subnets_secondary_ranges](outputs.tf#L28) | The secondary ranges associated with these subnets. |  |  |
| [vpc_access_connector_id](outputs.tf#L44) | ID of the VPC Serverless connector. format: `projects/{{project}}/locations/{{region}}/connectors/{{name}}` |  |  |
| [vpc_access_connector_name](outputs.tf#L38) | Name of the VPC Serverless connector |  |  |

<!-- END TFDOC -->
### Troubleshooting

* If the `data-ops-project-apply-<env>` pipeline fails, it could be from the DLP agent didn't get created (`service-PROJECT_NUMBER@dlp-api.iam.gserviceaccount.com`). To resolve, open cloud shell and use the new `data-ops` project. In Cloud Shell use the link [here](https://cloud.google.com/dlp/docs/iam-permissions#service_account) and use the command to create that needed service account.