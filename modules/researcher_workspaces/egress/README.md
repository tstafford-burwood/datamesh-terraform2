# Egress Project

### Project Resources
![](../../../../docs/egress-resources.png)


<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [buckets.tf](./buckets.tf) | None | <code>google</code> | <code>google_storage_bucket</code> |
| [composer_dags.tf](./composer_dags.tf) | None |  | <code>google_storage_bucket_object</code> · <code>local_file</code> |
| [data.tf](./data.tf) | None | <code>constants</code> |  |
| [functions.tf](./functions.tf) | None |  | <code>google_cloudfunctions_function</code> · <code>google_cloudfunctions_function_iam_member</code> · <code>google_storage_bucket_object</code> · <code>local_file</code> · <code>null_resource</code> |
| [iam.tf](./iam.tf) | None | <code>project_iam</code> · <code>project_iam_custom_role</code> | <code>google_project_iam_member</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>google</code> | <code>google_compute_project_metadata</code> |
| [org-pol.tf](./org-pol.tf) | None |  | <code>google_project_organization_policy</code> · <code>time_sleep</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [billing_account](variables.tf#L1) | Google Billing Account ID | <code>string</code> | ✓ |  |  |
| [external_users_vpc](variables.tf#L43) | List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC. | <code>list&#40;string&#41;</code> | ✓ |  |  |
| [lbl_department](variables.tf#L63) | Department. Used as part of the project name. | <code>string</code> | ✓ |  |  |
| [data_stewards](variables.tf#L37) | List of or users of data stewards for this research initiative. Grants access to initiative bucket in `data-ingress`, `data-ops`. Prefix with `user:foo@bar.com`. DO NOT INCLUDE GROUPS, breaks the VPC Perimeter. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [enforce](variables.tf#L19) | Whether this policy is enforce. | <code>bool</code> |  | <code>true</code> |  |
| [lbl_cloudprojectid](variables.tf#L57) | CPID that refers to a CMDB with detailed contact info | <code>number</code> |  | <code>111222</code> |  |
| [lbl_dataclassification](variables.tf#L52) | Data sensitivity | <code>string</code> |  | <code>&#34;HIPAA&#34;</code> |  |
| [project_admins](variables.tf#L31) | Name of the Google Group for admin level access. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [region](variables.tf#L13) | The default region to place resources. | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |  |
| [researcher_workspace_name](variables.tf#L7) | Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist. | <code>string</code> |  | <code>&#34;workspace-1&#34;</code> |  |
| [set_disable_sa_create](variables.tf#L25) | Enable the Disable Service Account Creation policy | <code>bool</code> |  | <code>true</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [external_gcs_egress_bucket](outputs.tf#L23) | Name of egress bucket in researcher data egress project. |  |  |
| [external_users_vpc](outputs.tf#L29) | List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC. |  | <code>foundation/vpc-sc</code> |
| [initiative](outputs.tf#L17) | Research Initiative value used in Application Integration |  |  |
| [project_id](outputs.tf#L1) | Project ID |  |  |
| [project_name](outputs.tf#L6) | Project Name |  |  |
| [project_number](outputs.tf#L11) | Project Number |  |  |

<!-- END TFDOC -->
