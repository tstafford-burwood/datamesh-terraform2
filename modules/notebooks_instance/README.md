# Terraform Module to create a User-Managed Notebook

JupyterLab access modes determine who can use the JupyterLab user interface of a user-managed notebooks instance.

User-managed notebooks instances support two access modes: `single user` and `service account`.

This module is focused on `single user only`. This mean, the specificed user account (`var.trusted_scientist`) is the only user with access to the JupyterLab interface.

>Note the account must have access to any necessary Google resources.
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [network](variables.tf#L12) | The name of the VPC that this instance is in. Format: projects/{project_id}/global/networks/{network_id} | <code>string</code> | ✓ |  |
| [project](variables.tf#L7) | The ID of the project in which the resource belongs. | <code>string</code> | ✓ |  |
| [subnet](variables.tf#L17) | The name of the subnet that this instance is in. Format projects/{project_id}/regions/{region}/subnetworks/{subnetwork_id} | <code>string</code> | ✓ |  |
| [boot_disk_size](variables.tf#L40) | The boot disks size. Minimum is 100. | <code>number</code> |  | <code>100</code> |
| [boot_disk_type](variables.tf#L34) | Possible disk types for notebook instances. | <code>string</code> |  | <code>&#34;PD_STANDARD&#34;</code> |
| [data_disk_size_gb](variables.tf#L52) | The size of the data disk in GB attached to the instance. Mininum of 100 | <code>number</code> |  | <code>0</code> |
| [data_disk_type](variables.tf#L46) | Possible disk types for notebook instances. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [disable_downloads](variables.tf#L88) | Disable the ability to download from the notebook. | <code>string</code> |  | <code>&#34;true&#34;</code> |
| [disable_nbconvert](variables.tf#L94) | Disable the ability to convert files to PDF, XLS, etc and download. | <code>string</code> |  | <code>&#34;true&#34;</code> |
| [disable_root](variables.tf#L82) | Disable root access on the notebook. | <code>string</code> |  | <code>&#34;true&#34;</code> |
| [disable_terminal](variables.tf#L100) | Disable terminals in the notebook. | <code>string</code> |  | <code>&#34;true&#34;</code> |
| [image_family](variables.tf#L64) | Use this VM image family to find the image; the newest image in this family will be used. | <code>string</code> |  | <code>&#34;tf-latest-cpu&#34;</code> |
| [machine_type](variables.tf#L28) | VM Image type | <code>string</code> |  | <code>&#34;n1-standard-1&#34;</code> |
| [no_proxy_access](variables.tf#L76) | The notebook instance will not register with the proxy. | <code>string</code> |  | <code>&#34;false&#34;</code> |
| [no_public_ip](variables.tf#L70) | No public IP will be assigned to this instance. | <code>string</code> |  | <code>&#34;true&#34;</code> |
| [notebook_name_prefix](variables.tf#L22) | Prefix for notebooks indicating in higher trusted environment. | <code>string</code> |  | <code>&#34;trusted&#34;</code> |
| [region](variables.tf#L106) | The region the subnet is deployed into. | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |
| [trusted_scientists](variables.tf#L1) | The list of trusted users. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |
| [vm_image_project](variables.tf#L58) | The name of the Google Cloud project that this VM image belongs to. Format: projects/{project_id} | <code>string</code> |  | <code>&#34;deeplearning-platform-release&#34;</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [notebook_instances](outputs.tf#L1) | A list of notebooks created (vm names) |  |
| [user_instance](outputs.tf#L11) | A map of user to instance. |  |
| [user_proxy_uri](outputs.tf#L6) | A map of user to their proxy uri. |  |

<!-- END TFDOC -->
