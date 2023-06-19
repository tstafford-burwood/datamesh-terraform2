# Directory to Provision a Cloud Composer Environment

![](../../../../docs/cloud-composer.png)

The purpose of this directory is to provision a Cloud Composer environment that is fully managed by GCP. Cloud Composer is a resource that allows for data orchestration workflows to be used. Primarily this will be used to take data from the staging project and move it to a researcher's workspace GCS ingress bucket.

This directory does not need to be updated when new research groups are onboarded into the SRDE. The purpose of this directory is to only maintain the Cloud Composer instance.




## Optional tfvar Fields to Configure

1. In the `terraform.tfvars` file in the [env](./env/) directory there are some optional fields that can be configured to customize the deployment of the Cloud Composer instance.

<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [composer.tf](./composer.tf) | None | <code>create_environment_v2</code> |  |
| [composer_dag.tf](./composer_dag.tf) | None |  | <code>google_storage_bucket_object</code> · <code>local_file</code> |
| [iam.tf](./iam.tf) | None | <code>folder_iam</code> | <code>google_project_iam_member</code> · <code>google_service_account</code> · <code>google_service_account_iam_member</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>constants</code> |  |
| [org-pol.tf](./org-pol.tf) | None |  | <code>google_project_organization_policy</code> · <code>time_sleep</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [allowed_ip_range](variables.tf#L29) | The IP ranges which are allowed to access the Apache Airflow Web Server UI. | <code title="list&#40;object&#40;&#123;&#10;  value       &#61; string&#10;  description &#61; string&#10;&#125;&#41;&#41;">list&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [cloud_sql_ipv4_cidr](variables.tf#L38) | The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. | <code>string</code> |  | <code>&#34;10.4.0.0&#47;24&#34;</code> |  |
| [composer_iam_roles](variables.tf#L11) | The IAM role(s) to assign to the Cloud Compuser service account, defined at the folder. | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;composer.worker&#34;,&#10;  &#34;roles&#47;iam.serviceAccountUser&#34;,&#10;  &#34;roles&#47;iam.serviceAccountTokenCreator&#34;,&#10;  &#34;roles&#47;bigquery.dataOwner&#34;,&#10;  &#34;roles&#47;dlp.jobsEditor&#34;,&#10;  &#34;roles&#47;storage.objectAdmin&#34;,&#10;  &#34;roles&#47;bigquery.jobUser&#34;,&#10;  &#34;roles&#47;bigquery.dataOwner&#34;,&#10;  &#34;roles&#47;bigquery.jobUser&#34;&#10;&#93;">&#91;&#8230;&#93;</code> |  |
| [enforce](variables.tf#L166) | Whether this policy is enforced. | <code>bool</code> |  | <code>true</code> |  |
| [env_variables](variables.tf#L56) | Variables of the airflow environment. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |  |
| [environment_size](variables.tf#L62) | The environment size controls the performance parameters of the managed Cloud Composer infrastructure that includes the Airflow database. Values for environment size are: ENVIRONMENT_SIZE_SMALL, ENVIRONMENT_SIZE_MEDIUM, and ENVIRONMENT_SIZE_LARGE. | <code>string</code> |  | <code>&#34;ENVIRONMENT_SIZE_SMALL&#34;</code> |  |
| [image_version](variables.tf#L68) | The version of Airflow running in the Cloud Composer environment. Latest version found [here](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions). | <code>string</code> |  | <code>&#34;composer-2.1.15-airflow-2.5.1&#34;</code> |  |
| [master_ipv4_cidr](variables.tf#L81) | The CIDR block from which IP range in tenant project will be reserved for the master. | <code>string</code> |  | <code>null</code> |  |
| [oauth_scopes](variables.tf#L93) |  | <code>set&#40;string&#41;</code> |  | <code>&#91;&#34;https:&#47;&#47;www.googleapis.com&#47;auth&#47;cloud-platform&#34;&#93;</code> |  |
| [pypi_packages](variables.tf#L100) |  Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. \"numpy\"). | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |  |
| [scheduler](variables.tf#L106) | Configuration for resources used by Airflow schedulers. | <code title="object&#40;&#123;&#10;  cpu        &#61; string&#10;  memory_gb  &#61; number&#10;  storage_gb &#61; number&#10;  count      &#61; number&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code title="&#123;&#10;  cpu        &#61; 0.5&#10;  memory_gb  &#61; 1.875&#10;  storage_gb &#61; 1&#10;  count      &#61; 1&#10;&#125;">&#123;&#8230;&#125;</code> |  |
| [srde_project_vms_allowed_external_ip](variables.tf#L5) | This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [web_server](variables.tf#L122) | Configuration for resources used by Airflow web server. | <code title="object&#40;&#123;&#10;  cpu        &#61; string&#10;  memory_gb  &#61; number&#10;  storage_gb &#61; number&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code title="&#123;&#10;  cpu        &#61; 0.5&#10;  memory_gb  &#61; 1.875&#10;  storage_gb &#61; 1&#10;&#125;">&#123;&#8230;&#125;</code> |  |
| [web_server_ipv4_cidr](variables.tf#L136) | The CIDR block from which IP range in tenant project will be reserved for the web server. | <code>string</code> |  | <code>&#34;10.3.0.0&#47;29&#34;</code> |  |
| [worker](variables.tf#L142) | Configuration for resources used by Airflow workers. | <code title="object&#40;&#123;&#10;  cpu        &#61; string&#10;  memory_gb  &#61; number&#10;  storage_gb &#61; number&#10;  min_count  &#61; number&#10;  max_count  &#61; number&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code title="&#123;&#10;  cpu        &#61; 0.5&#10;  memory_gb  &#61; 1.875&#10;  storage_gb &#61; 1&#10;  min_count  &#61; 1&#10;  max_count  &#61; 3&#10;&#125;">&#123;&#8230;&#125;</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [airflow_uri](outputs.tf#L5) | URI of the Apache Airflow Web UI hosted within the Cloud Composer Environment. |  |  |
| [composer_env_id](outputs.tf#L15) | ID of Cloud Composer Environment. |  |  |
| [composer_env_name](outputs.tf#L10) | Name of the Cloud Composer Environment. |  |  |
| [composer_version](outputs.tf#L36) | The version of composer that is deployed. |  |  |
| [dag_bucket_name](outputs.tf#L30) | Google cloud storage bucket name only without suffix |  |  |
| [email](outputs.tf#L51) | Cloud Composer service account email. |  |  |
| [gcs_bucket](outputs.tf#L25) | Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment. |  |  |
| [gke_cluster](outputs.tf#L20) | Google Kubernetes Engine cluster used to run the Cloud Composer Environment. |  |  |
| [id](outputs.tf#L46) | Cloud Composer account IAM-format email. |  |  |
| [name](outputs.tf#L57) | Cloud Composer Service account resource (for single use). |  |  |

<!-- END TFDOC -->
