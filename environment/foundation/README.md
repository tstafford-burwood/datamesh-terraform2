# Terraform Directory for Provisioning Foundational GCP SDE Components

## Guiding Principles

### Workspaces

Each environment (`dev`, `test`, `prod`, etc) corresponds to a different [Terraform workspace](https://www.terraform.io/language/state/workspaces) and deploys a version of the service to that environment. 

Workspace-separated environments use the same Terraform code but have different state files, which is useful if you want your environments to stay as similar to each other as possible. However you must manange your workspace in the CLI and be aware of the workspace you are working in to avoid accidentally performing operations on the wrong environment.

To help avoid working in the wrong environment, we will control the workspace programmatically using the build config files in the [cloudbuild directory](../../cloudbuild/). 

### Use environment branches for configurations

Separate branches will represent each environment.

![](../../docs/branches-root.png)

### Cloud Build

![](../../docs/cloudbuild-architecture.png)

### Override variables in a tfvars file

Each root module has a `variables.tf` file that will contain default values for that particular root module. If any of those default values need to overriden, a `terraform.tfvars` is provided in each root module in a sub-directory called `env`.

For example, [data-ops-project](../foundation/data-ops/) has a sub-directory called [env](../foundation/data-ops/env/) with a `terraform.tfvars` file that can be used to override any variable value in the [variables.tf](../foundation/data-ops/variables.tf).

#### Usage

Editing the `terraform.tfvars` file in the [data-ops-project](../foundation/data-ops/env/) will update override the `data_ops_admin_project_iam_roles` variable.

```diff
# terraform.tfvars
+data_ops_admin_project_iam_roles = [ "roles/bigquery.dataEditor", "roles/storage.admin", "roles/owner" ]
```
---

| Steps | Comments |
| ---   | ---      |
| [constants]() | No resources deployed, sets up global values |
| [cloudbuild-sde](##cloudbuild-sde) | Builds the triggers in cloud build |
| [folders](##01-folders) | Build the folder hierarchy and Org policy |
| [data-ingress](##01-folders) | Ingress project with GCS buckets|
| [image-project](##02-image-project) | Packer and Artifact registries |
| [data-ops]() | Create Cloud DNS and buckets to support Cloud Composer |
| [cloud-composer]() | Build Cloud Composer and DAGs|
| [data-lake]() | Build data lake and GCS buckets |
| [vpc-sc]() | Setup and configure the VPC Access context and perimeters |

## Overview

This directory contains several distinct Terraform modules and projects each within their own directory that must be applied separately, but in sequence. Each of these Terraform projects are to be layered on top of each other, running in the following order.

[constants](./constants/)

The contents in this directory are used to be shared across all of the foundation projects. It will share core values like the billing ID and setting up IAM access for projects being deployed.

[cloudbuild-sde](./cloudbuild-sde/)

This step sets up Cloud Build and the triggers for each of the stages below. Triggers are configured to run a `terraform plan` for any non environment branch and `terraform apply` when changes are merged to an environment branch (`main`). Usage instructions are available in the cloudbuid-sde [README](./cloudbuild-sde/README.md).

[folders](./folders/)

The contents in this directory build out the initial folder hiearchy and assign `Organizational Policies` at the top folder level.

After executing this step, you will have the following structure:

```hcl
. RestrictedWorkloads
.. fldr-HIPAA-{env}
|   └── fldr-workspace-1 (researcher initiative)
```

[data-ingress](./data-ingress/)

The contents in this directory are used to create the project to hold data ingress resources like GCS buckets and IAM roles.

After executing this step, you will have the following structure:

```hcl
. RestrictedWorkloads
.. fldr-HIPAA-{env}
|   ├── prj-data-ingress
|   └── fldr-workspace-1 (researcher initiative)
```

[image-project](./image/)

The contents in this directory are used to build a project to provision GCE images that will be shared to other projects like the researcher workspace.

After executing this step, you will have the following structure:

```hcl
.. fldr-HIPAA-{env}
|   ├── prj-images
|   ├── prj-data-ingress
|   └── fldr-workspace-1 (researcher initiative)
```

[data-ops](./data-ops/)

The contents in this directory are used to support the creation of a private Cloud Composer environment.

After executing this step, you will have the following structure:

```hcl
.. fldr-HIPAA-{env}
|   ├── prj-images
|   ├── prj-data-ingress
|   ├── prj-data-ops
|   └── fldr-workspace-1 (researcher initiative)
```

[composer](./data-ops/cloud-composer/)

The contents in this directroy are used to deploy Cloud Composer and DAGs.

[data-lake](./data-lake/)

The contents in this directory are used to create the project to for the data warehouse.

After executing this step, you will have the following structure

```hcl
.. fldr-HIPAA-{env}
|   ├── prj-images
|   ├── prj-data-ingress
|   ├── prj-data-lake
|   ├── prj-data-ops
|   └── fldr-workspace-1 (researcher initiative)
```

<!-- [06-researcher-workspace](../deployments/researcher-projects/)

Build the researchers workspace that includers their tooling and access to data resources like BigQuery and buckets.

```hcl
. Parent Folder
.. fldr-(Environment)
├── fldr-Foundation SDE
|   ├── prj-images
|   ├── prj-data-ingress
|   ├── prj-data-lake
|   └── prj-data-ops
└── fldr-Deployments SDE
|   └── fldr-research-1-sde
|       └── prj-workspace
``` -->

[vpc-sc](./vpc-sc/)

Builds the necessary Access Context, VPC Service Perimeters and bridges to protect projects.

<!--
The purpose of this directory is provision certain foundational resources in GCP that pertain to the SDE. As an example a Cloud Build Access Level is provisioned here and is separated from the [deployments](../deployments) directory. Since the Cloud Build Access Level is maintained at an Organizational Level it can be used for other projects and not necessarily the SDE if there are future needs for this.

## General Usage

1. From a best practice approach a new branch should generally be created from the `master` or `main` branch when working on new features or updates.
    1. Run `git checkout -b <BRANCH_NAME>`
1. Change into the desired directory that needs to have infrastructure code updated.
1. Edit either the `main.tf`, `variables.tf`, or `terraform.tfvars` file, depending on what needs to be updated.
1. If there are variables which are needed but not present in the `.tfvars` file those can be added and updated as needed.
1. In order to limit any auto-approved changes being made to your infrastructure there are two options.
    1. If you want to merge back into master you can edit out any `apply` steps within the Cloud Build YAML file that this pipeline is associated to so that only an `init` and `plan` are ran to show what the potential Terraform changes will do.
    1. If you are working out of a feature branch you can create a new Cloud Build trigger to monitor the feature branch, create a new Cloud Build YAML with only an `init` and `plan` step, then verify that the `plan` output is good to proceed forward with.
1. Save your files, `git add <files>`, `git commit -m "<MESSAGE>"`, `git push`.
1. If you were working out of a feature branch you can merge back into `master`.
    1. `git checkout <master or main>`, `git merge <FEATURE_BRANCH> --no-ff`
1. A manual pipeline run may need to be started after a merge is done if no edits have been done on the `included_files` after the merge. These are generally the `.tfvars` files which are monitored for changes to start the pipeline.
-->


#### References
* [Google's Best Practice for using Terraform](https://cloud.google.com/docs/terraform/best-practices-for-terraform#expressions)
* [Goolge's GitOps Approach](https://cloud.google.com/architecture/managing-infrastructure-as-code)
* [Terraform's Workspace using OSS](https://learn.hashicorp.com/tutorials/terraform/organize-configuration)