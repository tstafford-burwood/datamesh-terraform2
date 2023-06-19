# Research Workspace Module

This repository provides an opinionated wayt to deploy researcher workspace with the necessary resources to access data from the data lake.

## Reference Architecture
![](../../../../docs/workspace-resources.png)


The resources that this module will create are:

* One private GCE VM instance that pulls its image from the `image-factory` project. <i>Multiple VMs can be created</i>.
* Identity-Aware Proxy with the appropriate permissions for outside user access.
* Cloud DNS entries to access restricted Google APIs.
* Google Cloud Storage bucket for user data and a way to share data outside of the project.
* A service account for Compute Engine
* The `default-route` is replace with a custom default route that only allows instances with the `jupyter-notebook` tag to reach Google APIs.
* Firewall rules

## Detailed Resources

### IAM Roles Deployed
* Admins
    - "roles/compute.osLogin",
    - "roles/iam.serviceAccountUser",
    - "roles/iap.tunnelResourceAccessor",
    - "roles/storage.admin",
    - "roles/editor" # TEMP - BREAK GLASS
* Researchers
    - "roles/serviceusage.serviceUsageConsumer", # Grant user the ability to use Services
    - "roles/compute.viewer",                    # Allow researcher to view instance
    - "roles/browser",                           # Read access to browse hiearchy for the project
    - "roles/iap.tunnelResourceAccessor",        # Access tunnel resources which use IAP
    - "roles/compute.instanceAdmin.v1"
    - roles/iam.serviceAccountUser
* Service Account: `notebook-sa`
    - "roles/compute.osLogin",
    #"roles/iam.serviceAccountUser",
    - "roles/storage.admin",           # Grants full control over objects, including listing, creating, viewing, and deleting objects
    - "roles/compute.instanceAdmin.v1" # Full control of Compute Engine instances

### Service account
* One service accoutn called: `notebook-sa`


### VPC
* One VPC:
    - Name: `{workspace_name}-us-central1-subnet-01`
    - default deployment in `us-central`
    - Private access is eanbled
    - CIDR `10.20.0.0/24`

### Firewall Rules
* Three rules:
    1. `allow-ingress-rdp` allow ingress from IAP to TCP ports `22` and `3389`
    1. `allow-egress-google-managed-service` allow all egress to any port
    1. `deny-egress-all` deny all egress


### DNS Private Zones
* iap-tunnel-zone
* artifact-registry-zone
* container-registry-zone
* notebook-api-zone, notebook-cloud-zone, notebook-usercontent-zone


### GCS Buckets
* `sde-{env}-{region}-shared-{random-id}`


## Initial deployment
For an initial deployment, the [num_instances](./variables.tf#L29) needs to be `0` because a VPC perimeter and bridge must be established before the instance can read from the `image-factory` project.

## Prerequirements
### Prepare your local workstation

Researchers wanting to connect to the provisioned instance MUST have the Google Cloud SDK installed on their local workstation. The SDK establishes a micro-vpn between their local workstation and the instance in GCP.

#### Install Cloud SDK

THe Google Cloud SDK is used to interact with your GCP resources. [Installation instructions](https://cloud.google.com/sdk/docs/install) for multiple platforms are available online.

## Remote into the Private GCE Instance
### Authentication

After installing the gcloud SDK run `gcloud init` to set up the gcloud CLI. When executing the correct region and zone.

### Set the project

Ensure you are using the correct project. Replace any `my-project` with the name of the correct workspace project. It will look something like `{env}-{lbl}-init-wrkspc-{random-id}`

```
gcloud config set project `{env}-{lbl}-init-wrkspc-{random-id}`
```

### List the instances

List the instances in the project. There should be at least one and this will be the one we're going to connect to:
```
gcloud compute instances list

# output
NAME                          ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP  STATUS
project-x-deep-learning-vm-0  us-central1-b  n2-standard-2               10.20.0.7                 RUNNING
```

### Establish a connection to the instance

Establish a secure connection to the private instance running the below command:

```
gcloud beta compute start-iap-tunnel project-x-deep-learning-vm-0 3389 --local-host-port=localhost:3333 --zone=us-central1-b 
```

### RDP to the instance

From a Windows computer, open a run prompt and type in `mstsc /v:localhost:3333`. An RDP prompt will come up. Accept the certificate and login.

![](https://i.stack.imgur.com/jER1X.jpg)

## Setting Up Instance for new users

### Create a new local user
1. Login as sudo user and open a command prompt.
1. Create a new user and to the xRDP group:
    ```bash
    sudo adduser foo
    sudo usermod -G xrdp foo
    ``
1. Reboot for the new changes

### Mount GCS buckets
Here we want to mount the two GCS buckets from the data-lake and from the local research workspace.

1. Login as sudo user and open a command prompt.
1. Create 2 new directories and update permissions so all users have access
    ```bash
    sudo mkdir /research-data
    sudo mkdir /data-lake
    sudo chmod -R 757 /research-data
    sudo chmod -R 757 /data-lake
    ```
1. Add entries to fstab by typing `sudo nano /etc/fstab`. Adding entries to `fstab` will automatically mount the targets after a system reboot and to be mounted for any new user.
    ```bash
    ${DATALAKE_BUCKET} /data-lake gcsfuse rw,allow_other,file_mode=777,dir_mode=777,implicit_dirs,_netdev
    ${SHARED_BUCKET} /research-data gcsfuse rw,allow_other,file_mode=777,dir_mode=777,implicit_dirs,_netdev
    ```
    - `implicit_dirs` is used to display folder directories from a GCS bucket. Without this switch, the bucket will be mounted but any existing folders previous to the mount will not be present. Deeper discussion can be found [here](https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/semantics.md).
1. Save the entries.

To launch your Jupyter Lab instance running the following from a command line window:
```bash
jupyter-lab
```


## Confirm access to Apt repo

Once a VM has been deployed in the researcher workspace, you'll want to confirm the VM has access to the **Apt** repo. To do this, run the following `gcloud` command:

    
    gcloud artifacts packages list \
        --location=`REGION` \
        --repository=`REPOSITORY_NAME` \
        --project=`PROJECT`

    
- Replace `PROJECT` with the imaging project id.
- Replace `REPOSITORY_NAME` with the repo name, by default this is `apt-repo`.
- Replace `REGION` with the region the repo is located, by default is `us-central1`.

### Pull down packages from private Apt repo

The command to pull down a package from the private Apt repo in the image factoy is:

    sudo apt install `package-name`/apt-repo
    

- Replace `package-name` with the name of the package hosted in the private Apt repo.


### Manage OS Packages

You can store and manage private Debian packages and RPM packages in Artifact Registry Apt and Yum repositories. To add packages you must have both read and write permissions (`roles/artifactregistry.reader` & `roles/artifactregistry.writer`, or `roles/artifactregistry.repoAdmin`)for the repository to add packages. You can upload a package to repository using the Google Cloud CLI or you can import a package that is stored in Cloud Storage. The example below is using Google Cloud CLI. To use the Google Cloud Storage option and the original source: go to the [Artifact Registry link](https://cloud.google.com/artifact-registry/docs/os-packages/debian/manage-packages#direct-upload).

```gcloud artifacts apt upload `REPOSITORY` --location=`LOCATION` --source=`PACKAGES````

* `REPOSITORY` is the Artifact Registry repo name.
* `LOCATION` is the regional location of the repo. Default is `us-central`.
* `PACKAGES` is the path to the package.

For example, to upload the package `my-package.deb` to the Apt repo `my-repo` in the `us-central` location, run: 
```gcloud artifacts apt upload my-repo --location=us-central1 --source=my-package.deb```


<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [buckets.tf](./buckets.tf) | None | <code>google</code> |  |
| [cloud_dns.tf](./cloud_dns.tf) | None | <code>cloud_dns</code> |  |
| [composer_dag.tf](./composer_dag.tf) | None |  | <code>google_storage_bucket_object</code> · <code>local_file</code> |
| [data.tf](./data.tf) | None | <code>constants</code> |  |
| [iam-admins.tf](./iam-admins.tf) | None | <code>project_iam</code> · <code>project_iam_custom_role</code> |  |
| [iam-researchers.tf](./iam-researchers.tf) | None | <code>project_iam</code> | <code>google_project_iam_member</code> · <code>google_service_account_iam_member</code> · <code>google_storage_bucket_iam_binding</code> |
| [iam-serviceaccount.tf](./iam-serviceaccount.tf) | None | <code>project_iam</code> | <code>google_artifact_registry_repository_iam_binding</code> · <code>google_project_iam_member</code> · <code>google_service_account</code> · <code>google_storage_bucket_iam_binding</code> |
| [iam-stewards.tf](./iam-stewards.tf) | None | <code>project_iam</code> | <code>google_project_iam_member</code> · <code>google_storage_bucket_iam_binding</code> |
| [instances.tf](./instances.tf) | None | <code>private_ip_instance</code> | <code>google_compute_disk_resource_policy_attachment</code> · <code>google_compute_resource_policy</code> · <code>google_storage_bucket_object</code> · <code>local_file</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>google</code> | <code>google_compute_project_metadata</code> |
| [org-pol.tf](./org-pol.tf) | None |  | <code>google_project_organization_policy</code> · <code>time_sleep</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [billing_account](variables.tf#L1) | Google Billing Account ID | <code>string</code> | ✓ |  |  |
| [golden_image_version](variables.tf#L107) | Retrieves the specific custom image version from the image project. | <code>string</code> | ✓ |  |  |
| [lbl_department](variables.tf#L131) | Department. Used as part of the project name. | <code>string</code> | ✓ |  |  |
| [project_admins](variables.tf#L18) | Name of the Google Group for admin level access. | <code>list&#40;string&#41;</code> | ✓ |  |  |
| [data_stewards](variables.tf#L81) | List of or users of data stewards for this research initiative. Grants access to initiative bucket in `data-ingress`, `data-ops`. Prefix with `user:foo@bar.com`. DO NOT INCLUDE GROUPS, breaks the VPC Perimeter. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [force_destroy](variables.tf#L65) |  | <code></code> |  | <code>true</code> |  |
| [instance_machine_type](variables.tf#L29) | The machine type to create. For example `n2-standard-2`. | <code>string</code> |  | <code>&#34;n2-standard-2&#34;</code> |  |
| [instance_name](variables.tf#L41) | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | <code>string</code> |  | <code>&#34;deep-learning-vm&#34;</code> |  |
| [instance_tags](variables.tf#L47) | A list of network tags to attach to the instance. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#34;deep-learning-vm&#34;, &#34;jupyter-notebook&#34;&#93;</code> |  |
| [lbl_cloudprojectid](variables.tf#L121) | CPID that refers to a CMDB with detailed contact info | <code>number</code> |  | <code>111222</code> |  |
| [lbl_criticality](variables.tf#L126) | Low, Medium, High | <code>string</code> |  | <code>&#34;low&#34;</code> |  |
| [lbl_dataclassification](variables.tf#L116) | Data sensitivity | <code>string</code> |  | <code>&#34;HIPAA&#34;</code> |  |
| [num_instances](variables.tf#L23) | Number of instances to create. | <code>number</code> |  | <code>0</code> |  |
| [region](variables.tf#L12) | The default region to place resources. | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |  |
| [researcher_workspace_name](variables.tf#L6) | Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist. | <code>string</code> |  | <code>&#34;workspace-1&#34;</code> |  |
| [researchers](variables.tf#L75) | The list of users who get their own managed notebook. Do not pre-append with `user`. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [set_disable_sa_create](variables.tf#L53) | Enable the Disable Service Account Creation policy | <code>bool</code> |  | <code>true</code> |  |
| [set_trustedimage_project_policy](variables.tf#L101) | Apply org policy to set the trusted image projects. {{UIMeta group=0 order=18 updatesafe }} | <code>bool</code> |  | <code>true</code> |  |
| [set_vm_os_login](variables.tf#L59) | Enable the requirement for OS login for VMs | <code>bool</code> |  | <code>true</code> |  |
| [snapshot_days_in_cycle](variables.tf#L136) | The numbe of days between snapshots | <code>number</code> |  | <code>1</code> |  |
| [snapshot_max_retention_days](variables.tf#L148) | Maximum age of the snapshot that is allowed to be kept. | <code>number</code> |  | <code>7</code> |  |
| [snapshot_start_time](variables.tf#L142) | The time to start the snapshot. This must be in UTF format. | <code>string</code> |  | <code>&#34;07:00&#34;</code> |  |
| [stewards_project_iam_roles](variables.tf#L87) | The IAM role(s) to assign to the `Data Stewards` at the defined project. | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;roles&#47;container.clusterViewer&#34;, &#35; Provides access to get and list GKE clusters - used to view Composer Environemtn&#10;  &#34;roles&#47;composer.user&#34;,&#10;  &#34;roles&#47;monitoring.viewer&#34;, &#35; read-only access to get and list info about all monitoring data&#10;  &#34;roles&#47;logging.viewer&#34;,    &#35; see longs from within Cloud Composer&#10;  &#34;roles&#47;dlp.admin&#34;,&#10;  &#34;roles&#47;integrations.integrationInvoker&#34;, &#35; Can invoke &#40;run&#41; integrations,&#10;  &#34;roles&#47;integrations.integrationAdmin&#34;,   &#35; Full access to all Application Integration resources&#10;&#93;">&#91;&#8230;&#93;</code> |  |
| [vm_disk_size](variables.tf#L35) | How big of an OS disk size to attach to instance. | <code>number</code> |  | <code>100</code> |  |
| [zone](variables.tf#L69) | Zone where the instances should be created. If not specified, instances will be spread across available zones in the region. | <code>string</code> |  | <code>null</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [data_stewards](outputs.tf#L53) | List of data stewards |  | <code>foundation/vpc-sc</code> |
| [notebook_sa_email](outputs.tf#L27) | Notebook service account |  |  |
| [notebook_sa_member](outputs.tf#L37) | Notebook service account identity in the form `serviceAccount:{email}` |  | <code>foundation/vpc-sc</code> |
| [notebook_sa_name](outputs.tf#L32) | Notebook service account fully-qualified name of the service account |  |  |
| [vm_id](outputs.tf#L48) | The server-assigned unique identifier of this instance. |  |  |
| [vm_name](outputs.tf#L43) | Compute instance name |  |  |
| [workspace_network_name](outputs.tf#L17) | The name of the VPC being created |  |  |
| [workspace_project_id](outputs.tf#L1) | Researcher workspace project id |  | <code>data-ops-project/set_researcher_dag_envs.py</code> |
| [workspace_project_name](outputs.tf#L7) | Researcher workspace project number |  |  |
| [workspace_project_number](outputs.tf#L12) | Researcher workspace project number |  |  |
| [workspace_subnets_names](outputs.tf#L22) | The names of the subnets being created |  |  |

<!-- END TFDOC -->
### References
* Google's document on [Using Cloud IAP for TCP Forwarding](https://cloud.google.com/iap/docs/using-tcp-forwarding)
* Google's document on [Tunneling RDP Connections](https://cloud.google.com/iap/docs/using-tcp-forwarding#tunneling_rdp_connections)