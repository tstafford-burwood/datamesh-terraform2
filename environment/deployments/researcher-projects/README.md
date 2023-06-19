# Terraform Directory for Provisioning Tenants

## Guiding Principles

This directory is used when a researcher workspace or tenant, needs to be provisioned or updated. The end goal of this directory is to provision secured GCP projects that allows researchers to perform necessary work on protected data.

**Use folders for configurations**

Unlike the core [Foundation which uses Git branches](../../foundation/README.md) to separate configurations, the workspaces/tenants will use a folders structure to separate out environments which may not be exact copies of each other.

**Environments**

To re-use code, but have different environments the "workspace" comprises of two projects: [egress project](./egress/README.md) and [workspace project](./workspace/README.md). These Terraform templates are varaiblesed to allow for different inputs. The default inputs can be overrided with a [Terraform *.tfvars]() file which allow for different environments.

To be able to deploy multiple enivonments, a directory called [env](./env) is provided. This folder contains a top level folder that's named after the desired tenant name, and sub-folders which contain the [*.tfvars]() for each of the projects.

### Create new tenants

Follow the [New Tenant Readme](./new-tenant.md) for a detailed description on how to create a new workspace/tenant.

### Create new Application Integration

Click [here](./application-integration.md) for instructions.

## Overview

| Steps | Comments |
| --- | --- |
| Globals | No resources are deployed, only global values are configured|
| Egress | Deploys a project with a bucket to be shared with other researchers |
| Workspace | Deploys a project with a VM instance and tools for researchers |
| VPC SC | Create a VPC Service perimeter around the projects and VPC SC bridges to other foundation projects |


This directory contains several distinct Terraform modules and projects each within their own directory that must be applied separately, but in sequence. Each of these Terraform projects are to be layered on top of each other, running in the following order.

[globals](./env/template/globals.tfvars)

The contents in this directory are used to be shared across all of the researcher initiative projects. It will share core values like the Billing ID and the researcher_workspace_name.

[egress](./egress/)

The contents in this directory are used to create the researcher's egress project. The resources in this project are used to share out contents like a GCS bucket.

After executing this step, you will have the following structure:

```bash
.. fldr-HIPAA-{env}
|   ├── prj-images
|   ├── prj-data-ingress
|   ├── prj-data-lake
|   ├── prj-data-ops
|   └── fldr-workspace-1 (researcher initiative)
|        └── prj-egress
```

[workspace](./workspace/)

The contents in this directory are used to create the researcher's workspace project. The resources in this project are VM instances that researchers' will remote into. The tools will be pre-installed for the researcher. Other resources like GCS buckets for scratch space and backups will be configured.

After executing this step, you will have the following structure:

```bash
.. fldr-HIPAA-{env}
|   ├── prj-images
|   ├── prj-data-ingress
|   ├── prj-data-lake
|   ├── prj-data-ops
|   └── fldr-workspace-1 (researcher initiative)
|        ├── prj-egress
|        └── prj-wrkspce
```

[vpc-sc](./vpc-sc/)

The contents in this directory creates a VPC Service Control perimeter and puts the `egress` and `workspace` projects inside of the perimeter. Additional bridges are built so connectivity is established between the researcher projects and the foundation projects.
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [billing_account](variables.tf#L1) | Google Billing Account ID. If left blank, the value from constants.tf will be used. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [data_stewards](variables.tf#L61) | List of or users of data stewards for this research initiative. Grants access to initiative bucket in `data-ingress`, `data-ops`. Prefix with `user:foo@bar.com`. DO NOT INCLUDE GROUPS, breaks the VPC Perimeter. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |
| [external_users_vpc](variables.tf#L67) | List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |
| [golden_image_version](variables.tf#L31) | Retrieves the specific custom image version from the image project. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [instance_name](variables.tf#L25) | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | <code>string</code> |  | <code>&#34;deep-learning-vm&#34;</code> |
| [lbl_department](variables.tf#L13) | Department. Used as part of the project name. | <code>string</code> |  | <code>&#34;pii&#34;</code> |
| [num_instances](variables.tf#L19) | Number of instances to create. | <code>number</code> |  | <code>0</code> |
| [project_admins](variables.tf#L73) | Name of the Google Group for admin level access. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |
| [region](variables.tf#L7) | The default region to place resources. If left blank, the value from constants.tf will be used. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [researcher_workspace_name](variables.tf#L37) | Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist. | <code>string</code> |  | <code>&#34;workspace-1&#34;</code> |
| [researchers](variables.tf#L55) | The list of users who get their own managed notebook. Do not pre-append with `user`. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |
| [set_disable_sa_create](variables.tf#L49) | Enable the Disable Service Account Creation policy | <code>bool</code> |  | <code>true</code> |
| [set_vm_os_login](variables.tf#L43) | Enable the requirement for OS login for VMs | <code>bool</code> |  | <code>true</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [data_stewards](outputs.tf#L33) | List of data stewards |  |
| [egress_project_id](outputs.tf#L3) | Project ID |  |
| [egress_project_name](outputs.tf#L8) | Project Name |  |
| [egress_project_number](outputs.tf#L13) | Project Number |  |
| [external_gcs_egress_bucket](outputs.tf#L19) | Name of egress bucket in researcher data egress project. |  |
| [external_users](outputs.tf#L25) | List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC. |  |
| [notebook_sa_member](outputs.tf#L61) | Notebook service account identity in the form `serviceAccount:{email}` |  |
| [researchers](outputs.tf#L39) | List of researchers |  |
| [vm_name](outputs.tf#L67) | Compute instance name |  |
| [workspace_1_id](outputs.tf#L45) | Researcher workspace project id |  |
| [workspace_1_name](outputs.tf#L51) | Researcher workspace project number |  |
| [workspace_1_number](outputs.tf#L56) | Researcher workspace project number |  |

<!-- END TFDOC -->
