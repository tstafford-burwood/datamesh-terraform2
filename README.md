# Secure Data Enclave

This module implements an opinionated Secure Data Enclave architecture that creates and setup projects and related resources that compose an end-to-end environment.

The following diagram is a high-level reference of the resources created and managed here:

![](./docs/overview.png)

## Overview
### Organization-level Structure

The code in this repository address Organization-level configurations. Those configs are:
- **Organization Policies** Used to define constraints for the projects.
- **VPC Service Controls** Used to help restrict data exfiltration.
- **Logging** Used to enable additional logging features to capture when data is read.

### Project Structure

- **data-ingress** Used to store temporary data. Data is pushed to Cloud Storage.
- **data-ops** Used to host Cloud Composer (AirFlow), which orchestrates all tasks that move data cross projects.
- **data-lake** Used to host data for researcher initiatives. Resources are configured with a retention policy.
- **workspace** Used to host researcher tooling and other resources.
- **egress** Used to host resources that share data with external entities.

### Roles

We assign roles on resources at the project level, granting the appropriate roles via groups (humans) and service accounts (services and applications) according to best practices.

### Service Accounts

Service account creation follows the least privilege principle, performing a single task which requires access to a defined set of resources. The table below shows a high level overview of roles for each service account. For detailed roles, please refer to the code.

| Service Account | Data Ingress | Data Lake | Data Ops | Egress | Wrkspc |
| :-: | :-: | :-: | :-: | :-: | :-: |
| `composer-sa`   | `read`       | `write`   | `read`/`write` | `write` | `read` |
| `notebook-sa` | - | `read` | - | - | `read`/`write` |

### Groups

User groups provide a stable frame of reference that allows decoupling the final set of permissions from the stage where entities and resources are created, and their IAM binding defined. The personas that can use `groups` are defined below:

[We use groups to control access to resources:](./environment/foundation/constants/README.md#foundation-user-groups)

- *Admins* They handle and run the Data Hub, with read access to all resources in order to troubleshoot possible issues with pipelines.

- *Researchers* They perform analysis on datasets, with read access to the Data Lake project using impersonation of the service account.

| User/Group | Imaging | Data Ingress | Data Lake | Data Ops | Egress | Wrkspc |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|Admins|`ADMIN`|`ADMIN`|`ADMIN`|`ADMIN`|`ADMIN`|`ADMIN`|
|Researchers|-|-|-|-|`read`|`read`/`write`|

### Users

Single user accounts for `data_stewards` must be used over groups because of the [VPC service control has a limitation using Google Groups](https://cloud.google.com/vpc-service-controls/docs/use-access-levels).

[We use individual accounts to control access to resources](./environment/deployments/researcher-projects/env/template/workspace/terraform.tfvars)

- *Data Stewards* They perform the data orchestration.

| User/Group | Imaging | Data Ingress | Data Lake | Data Ops | Egress | Wrkspc |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|Stewards|-|`read`/`write`|-|`read`|-|-|


### Virtual Private Cloud (VPC) design


### IP ranges and subnets

The SDE will reserve the following IP address blocks for GCP, note not all project require a VPC with networking.

| Project | Address | Region |
|:-:|:-:|:-:|
|Data Ingress | `172.16.0.0/24` | `us-central` |
| Imaging | `10.1.0.0/24` | `us-central` |
| Data Ops | `10.0.0.0/20`<br>`10.1.0.0/20`<br>`10.2.0.0/24`| `us-central`|
| Workspace | `10.20.0.0/20` | `us-central` |

### VPC Service Control

To protect Google Cloud services in your projects and mitigate the risk of data exfiltration, you can specify service perimeters at the project level. Think of it as a firewall for Google APIs.


Service perimeter birdge



**Access Context**

An access level defines a set of attributes that a request must meet for the request to be honored. Access levels can include various criteria, such as IP address and user identity. In this deployment identities are the primary success criteria.
>**Note**: For identities, only service accounts and user accounts are allowed. No groups.

| Name | Accounts | Description |
| --- | --- | --- |
| sde_{env}_cloudbuild | Cloud Build service accounts, `notebook-sa`, `composer-sa`, `prisma-sa` | Any service account needed for communcation is added here.|
| sde_{env}_stewards | Any steward added to the [environmental tfvars file](./environment/deployments/researcher-projects/env/template/workspace/terraform.tfvars#L3). | Allow Stewards access into the different SDE foundation projects. |
| sde_{env}_{research_init}_users | Admin accounts added to the [environmental tfvars file](./environment/deployments/researcher-projects/env/template/workspace/terraform.tfvars#L1) | na |

**Service Perimeter**
| Name | Projects | Description |
| --- | :-: | --- |
| {env}_foundation | `data-ingress`<br>`data-ops`<br>`data-lake` | Perimeter around the core SDE foundation.
| {env}_foudation_imaging | `imaging-factory` | Broken out from SDE core to allow storage api access for researcher personas to access and download loginscript from GCS bucket.
| {env}_{research_init} | `egress`<br>`workspace` | Perimeter to prevent access to storage related APIs from outside the VPC.

**Service Bridge**

A project can only be assigned to one service perimeter. To allow
communicatino between projects a perimeter bridge must be formed. In this deployed, 2 sets of bridges are created.

| Name | Projects |
| --- | :-: |
| env_bridge_image_prj_{research_init} | `workspace <-> image-factory` |
| env_bridge_foundation_{research_init} | `egress,worksace <-> data-ops, data-lake` |

>**Note**: replace `env` with environment and `research_init` with the researcher's initiative.



## Getting Started

To deploy a fresh install or to maintain, click [here](./environment/README.md).

## FAQ

Click [here](./FAQ.md) for Frequently Asked Questions



<!-- 

The SDE environment is broken into two main parts: `Foundation` and `Deployments`. 
* `Foundation` contains the core Secure Data Environment parts for data ingress, orchestration, and sharing.
* `Deployments` contains researcher workspaces that are projects where researchers perform their work and another project that is used to share data outside of Google.

This repo contains several distinct Terraform projects, each within their own directory that must be applied separately, but in sequence. Each of these Terraform projects are to be layered on top of each other, and must be ran in order.

To help with this sequence, a [Cloud Build workflow configuration file](./cloudbuild/foundation/workflow-foundation-apply.yaml) has been developed to provision the environment in the appropriate sequence.

### Bootstrap

To deploy the workflow configuration file a new temporary Cloud Build file needs to be created -->
