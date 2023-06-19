# Terraform Module that create a Managed Notebook

This terraform module will provision a managed notebook in Vertex AI.

JupyterLab access modes determine who can access JupyterLab user interface.

There are two options: `single user only` and `service account`.

This module is focused on `single user only`. This mean, the specificed user account (`var.trusted_scientist`) is the only user with access to the JupyterLab interface.
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [project](variables.tf#L13) | The ID of the project in which the resource belongs. | <code>string</code> | ✓ |  |
| [access_mode](variables.tf#L7) | Access modes determine who can use a notebook instance and which creds are used to call Google APIs. Cannot be changed once notebook is created. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [boot_disk_size](variables.tf#L78) | The boot disks size. Minimum is 100. | <code>number</code> |  | <code>100</code> |
| [boot_disk_type](variables.tf#L72) | Possible disk types for notebook instances. | <code>string</code> |  | <code>&#34;PD_STANDARD&#34;</code> |
| [disable_downloads](variables.tf#L18) | Option to disable downloads from the managed notebook. | <code>bool</code> |  | <code>true</code> |
| [disable_nbconvert](variables.tf#L24) | Option to disable nbconvert from the managed notebook. | <code>bool</code> |  | <code>true</code> |
| [enable_integrity_monitoring](variables.tf#L42) | Enable integrity monitoring | <code>bool</code> |  | <code>true</code> |
| [enable_secure_boot](variables.tf#L30) | Enable secure boot for managed notebook. | <code>bool</code> |  | <code>false</code> |
| [enable_vtpm](variables.tf#L36) | Enable vTPM for managed notebook. | <code>bool</code> |  | <code>true</code> |
| [idle_shutdown](variables.tf#L114) | Runtime will automatically shutdown after `idle_shutdown_timeout`. | <code>string</code> |  | <code>&#34;true&#34;</code> |
| [idle_shutdown_timeout](variables.tf#L120) | Time in minutes to wait before shuting down runtime. | <code>number</code> |  | <code>30</code> |
| [machine_type](variables.tf#L66) | VM Image type | <code>string</code> |  | <code>&#34;n1-standard-1&#34;</code> |
| [network](variables.tf#L90) | The name of the VPC that this instance is in. Format: projects/{project_id}/global/networks/{network_id} | <code>string</code> |  | <code>&#34;&#34;</code> |
| [notebook_name_prefix](variables.tf#L60) | Prefix for notebooks indicating in higher trusted environment. | <code>string</code> |  | <code>&#34;trusted&#34;</code> |
| [region](variables.tf#L84) | The subnetwork region | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |
| [repository](variables.tf#L48) | Path to the image repository | <code>string</code> |  | <code>&#34;gcr.io&#47;deeplearning-platform-release&#47;base-cpu&#34;</code> |
| [reserved_ip_range](variables.tf#L102) | Reserved IP Range name is used for VPC Peering. The subnetwork allocation will use the range `name` if it's assigned. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [role](variables.tf#L108) | IAM role to be assigned to instance. | <code>string</code> |  | <code>&#34;roles&#47;notebooks.viewer&#34;</code> |
| [subnet](variables.tf#L96) | The name of the subnet that this instance is in. Format projects/{project_id}/regions/{region}/subnetworks/{subnetwork_id} | <code>string</code> |  | <code>&#34;&#34;</code> |
| [tag](variables.tf#L54) | The tag of the container image. | <code>string</code> |  | <code>&#34;lastest&#34;</code> |
| [trusted_scientists](variables.tf#L1) | The list of individual trusted users. Use their full email address like `foo@example.com`. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [proxy_uri](outputs.tf#L1) | The proxy endpoint that is used to access the runtime. |  |

<!-- END TFDOC -->
