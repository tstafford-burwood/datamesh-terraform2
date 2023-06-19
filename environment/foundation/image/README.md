# Terraform Directory for Packer Project

This repository provides an opinionated way to deploy a project that's ready to deploy HashiCorp Packer.

## Reference Architecture
![](../../../docs/image-project.png)

This modules is used to deploy infrastructure for a Compute Engine image builder based on Hashicorps Packer Tool.

The purpose of this directory is to provision a standalone project that will store a Packer container image in Google Container Registry (GCR). This container image is then used to run the Packer application. This project will also maintain VM images that will be used with researcher workspace VMs.

The resources that this module will create are:

### VPC
* One VPC:
    - Name: `image-factory-us-central1-subnet-01`
    - default deployment in `us-central`
    - Private access is eanbled
    - CIDR `10.1.0.0/24`

### Firewall Rules

* One firewall rule:
    - allow ingress from `0.0.0.0/0` over TCP on ports `22`, `5985`, `5986`

### Artifact Registry
* Three private registries:
    - One for the packer container
    - One for the DLP container (<i>Optional</i>)
    - One for the APT repo

### GCS Bucket
* A new GCS bucket is created per researcher initiative. This is based off of the subfolder value located [here](../folders/variables.tf#L1).

### Service Accounts
* One service account
    - `image-builder` - Used by Packer to connect and provision an instance

### IAM Roles
* Project level admins that are defined in the [constants.tf](../constants/constants.tf#L17)
    - "roles/deploymentmanager.editor"
    - "roles/artifactregistry.admin"
    - "roles/compute.admin"
    - "roles/editor"
* `image-builder` 
    - "roles/compute.instanceAdmin.v1",
    - "roles/iam.serviceAccountUser"
* `cloudbuild-sa` that is defined in the [constants.tf](../constants/constants.tf)
    - "roles/iam.serviceAccountTokenCreator"

## Using Packer's service account
Allow the default [Cloud Build service account](../constants/constants.tf#L12) to impersonate the [Packer Service Account](./iam.tf#L12)

## Configuring Packer
Once the `image-factory` project has been provisioned with necessary Artifact Registry repos, an initial Packer container must be provisioned. A Cloud Build pipeline, called [{env}-packer-container-image](../cloudbuild-sde/triggers-container.tf#L1) is available. This trigger watches for any changes to the [Docker](./packer-container/Dockerfile) file. Make any arbitrary change (add a comment, new line, anything) to kick off the build.

This [yaml file](../../../cloudbuild/foundation/image-container.yaml) are the build steps to create the container and push into the `Packer Artifact Registry`.

## Create a Researcher Image
After the packer container has been created, a researcher workspace image can be created. A Cloud Build pipeline called [{env}-researcher-vm-image](../cloudbuild-sde/triggers-container.tf) is available. This trigger watches for any changes to [this yaml file](../../../cloudbuild/foundation/packer-researcher-vm.yaml). Make any arbitrary change or update the provisioner section to add new software.

## Accessing resources over the Internet
This module assumes that provisioning of a Compute Engine VM requires access to the resources over the Internet (ie  to isntall OS packages, etc). The compute VM will be assigned a dynamic public IP address to connect over the Internet.

## Scripts Bucket
A "scripts" bucket per researcher initiative is provisioned. Scripts to connect to instances will be uploaded into this bucket.

## Manage Debian Packages

You can store and manage private Debian packages and RPM packages in Artifact Registry Apt and Yum repositories. Managing your OS packages in Artifact Registry provides:
* Control over the Linux packages that your organization installs on both Compute Engine VMs and Linux VMs outside of Google Cloud.
* Access to OS packages when VMs do not have external internet access or when public repositories have a service outage.

### Adding Debian Packages

* Here's a link to the Google documentation on how to [add, view and install new packages](https://cloud.google.com/artifact-registry/docs/os-packages/debian/manage-packages).

### Configure VMs to install Debian Packages

The steps below define how to configure the Packer VM to access the repo and the commands to configure the golden image to retrieve packages hosted from the private **Apt** repo.

1. The service account, `image-builder` to access the `apt-repo` registry has all the necessary permissions at the project level ([Artifact Registry Reader](./iam.tf#L30)) and at the VM instance level ([cloud-platform](../../../cloudbuild/foundation/packer.json#L37)).
1. Prepare the VM to access the repository. The necessary lines below are for reference and have been included in the [Packer yaml file](../../../cloudbuild/foundation/packer.json).
    ```bash
    echo 'deb http://packages.cloud.google.com/apt apt-transport-artifact-registry-stable main' | sudo tee -a /etc/apt/sources.list.d/artifact-registry.list
    sudo apt update
    sudo apt install apt-transport-artifact-registry
    ```

### Confirm access to Apt repo

Once a VM has been deployed in the researcher workspace, you'll want to confirm the VM has access to the **Apt** repo. To do this, run the following `gcloud` command:

    ```gcloud
    gcloud artifacts packages list \
        --location=<REGION> \
        --repository=<REPOSITORY_NAME> \
        --project=<PROJECT>
    ```
    
- Replace <PROJECT> with your Google Cloud project id hosting the repo.
- Replace <REPOSITORY_NAME> with the repo name, by default is `apt-repo`.
- Replace <REGION> with the region the repo is located, by default is `us-central`.



<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [buckets.tf](./buckets.tf) | None |  | <code>google_storage_bucket</code> · <code>random_id</code> |
| [iam.tf](./iam.tf) | None | <code>project_iam</code> | <code>google_service_account</code> · <code>google_service_account_iam_binding</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>artifact_registry</code> · <code>constants</code> · <code>firewall-rules</code> · <code>google</code> |  |
| [org-pol.tf](./org-pol.tf) | None |  | <code>google_project_organization_policy</code> · <code>time_sleep</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [enforce](variables.tf#L16) | Whether this policy is enforced. | <code>bool</code> |  | <code>true</code> |  |
| [image_project_iam_roles](variables.tf#L5) | The IAM role(s) to assign to the member at the defined project. | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;deploymentmanager.editor&#34;, &#35; Provides the permissions necessary to create and manage deployments.&#10;  &#34;roles&#47;artifactregistry.admin&#34;,   &#35; Administrator access to create and manage repositories.&#10;  &#34;roles&#47;compute.admin&#34;,            &#35; Full control of all Compute Engine resources.&#10;  &#34;roles&#47;editor&#34;&#10;&#93;">&#91;&#8230;&#93;</code> |  |
| [inherit](variables.tf#L41) | Inherit from parent | <code>bool</code> |  | <code>false</code> |  |
| [set_disable_sa_create](variables.tf#L34) | Enable the Disable Service Account Creation policy | <code>bool</code> |  | <code>true</code> |  |
| [set_external_ip_policy](variables.tf#L28) | Enable org policy to allow External (Public) IP addresses on virtual machines. | <code>bool</code> |  | <code>true</code> |  |
| [set_resource_location](variables.tf#L22) | Enable org policy to set resource location restriction | <code>bool</code> |  | <code>false</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [apt_repo_id](outputs.tf#L81) | An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}. |  |  |
| [apt_repo_name](outputs.tf#L86) | The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1` |  | <code>workspace</code> |
| [dlp_container_artifact_repo_id](outputs.tf#L71) | An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}. |  |  |
| [dlp_container_artifact_repo_name](outputs.tf#L76) | The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1` |  |  |
| [image_build_email](outputs.tf#L20) | Image build sa email |  | <code>packer</code> · <code>pipeline</code> |
| [image_build_name](outputs.tf#L26) | Image builder SA name |  | <code>packer</code> · <code>pipeline</code> |
| [image_builder_vm](outputs.tf#L32) | The name of the Packer builder VM |  | <code>packer</code> · <code>pipeline</code> |
| [network_name](outputs.tf#L42) | The name of the VPC being created |  |  |
| [packer_container_artifact_repo_id](outputs.tf#L61) | An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}. |  |  |
| [packer_container_artifact_repo_name](outputs.tf#L66) | The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1` |  |  |
| [project_id](outputs.tf#L5) | Project Id |  |  |
| [project_name](outputs.tf#L10) | Project Name |  |  |
| [project_number](outputs.tf#L15) | Project Number |  |  |
| [research_to_bucket](outputs.tf#L92) | Map of researcher name to their bucket name |  | <code>workspace</code> |
| [subnets_names](outputs.tf#L47) | The names of the subnets being created |  |  |
| [subnets_regions](outputs.tf#L52) | The region where the subnets will be created. |  |  |

<!-- END TFDOC -->
