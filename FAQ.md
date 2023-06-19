# FAQ

* **What is the syntax for adding single users, groups, or service accounts?**
    * The prefix will be `user:<user@email.com>` for users, `group:<group@email.com>` for groups, and `serviceAccount:<serviceaccoun@email.com>`.
    * There are three main locations that control user access
        1. <u>Foundation</u>:
            * Accounts that have permission to the foundational projects are in the [constants.tf](./environment/foundation/constants/constants.tf) file.
        1. <u>Egress</u>:
            * Accounts that have permission to the egress project are in the [variables.tf](./environment/deployments/researcher-projects/egress/variables.tf)
        1. <u>Workspace</u>:
            * Accounts that have permission to the workspace project are in the [variables.tf](./environment/deployments/researcher-projects/workspace/variables.tf)
* **If there are additional resources that researchers would like to leverage within a SDE (e.g. database), how do we go about provisioning? Where do we put the code?**
    * There are many factors to think about when adding in a new resource: Does this new resource need to be standard for every build? Does this go in the foundation or under deployments?

    >For this simulated question, we will outline some of the high-level guidelines to help lay the path for new cloud resources, deploying with code.

    For this simulated question, we will deploy a new Cloud SQL instance for a new researcher initiative. This new initiative will be a fork from the current [workspace](./environment/deployments/researcher-projects/workspace/) we have developed.

    1. Deploy the new researcher initiative following [these instructions](./environment/README.md#deploying-researcher-deployments-with-cloud-build).
        > This creates the folder hierarchy and triggers in Cloud Build.
    1. Copy the existing [Cloud Build configuration file](./cloudbuild/deployments/researcher-workspace-project-apply.yaml) and rename it to something that doesn't create a name conflict.
    1. Copy the existing [workspace directory](./environment/deployments/researcher-projects/workspace/) and rename it something different so the names don't conflict.
    1. Under the new workspace directory, create a new file called `cloudsql.tf`.
        > Populate the file using the [terraform-google-sql-db](https://github.com/terraform-google-modules/terraform-google-sql-db) public module to get started.
    1. Update the trigger in Cloud Build associated with the new researcher initiative. 
        > Change the `Cloud Build configuration file location` value to the path of the new researcher-workspace Cloud Build configuration file.
    1. Run the Cloud Build pipeline associated with the new researcher initiative.
* **On the [egress folder](./environment/deployments/researcher-projects/egress/), what permisions do project admins and users roles have?**
    * The IAM permissions are located [here](./environment/deployments/researcher-projects/egress/iam.tf). For `admins` the `owner` role is available for "BREAK GLASS" situations. This is not enabled by default and must be uncommented to be activated.
* **Do departmental IT admins get privileges by default?**
    * By deafult, no. They must be added to the appropriate researcher tenant tfvars file. For example, to add a department IT admin to the research workspace they admins name or group needs to be added [here](./environment/deployments/researcher-projects/env/template/workspace/terraform.tfvars)
    * If departmental IT admins are not explicitely defined in this repo, then the other way to grant IAM roles would be with someone who has [GCP Organization Admin](https://cloud.google.com/resource-manager/docs/creating-managing-organization#adding_an_organization_administrator) role and assigning users or groups at the folder level or individual project level.
* **When the [reseracher workspace](./environment/deployments/researcher-projects/workspace/) is deployed, how is the VM configures in terms of snapshots?**
    * By default, the VM instances will have a snapshot schedule attached to the primary disk. The snapshots are set to start every day at `07:00 UTC` and to be kept for 7 days.
    * These values can change and are located in the [variables.tf](./environment/deployments/researcher-projects/workspace/variables.tf) file and can be exposed to the `*.tfvars*` to override the default behavior.
    <!-- * For brand new deployments, the workspace [VM instance](./environment/deployments/researcher-projects/workspace/variables.tf#L29) value must be set to 0 because the VPC Service Control perimeter and bridge must be established between the workspace and the image-project. After the VPC SC is established, the VM instance for the workspace can be deployed.
    * When deploying the VM instance, the Terraform code will read the latest [image version](./environment/deployments/researcher-projects/workspace/data.tf#L99) and use it as the boot disk (IE: `packer-data-science-001`). When the base image has been update a new image will be created and used (`packer-data-science-002`). To deploy that new image to the instance in the workspace, run the workspace pipeline. When the Terraform code is ran, it will read the latest image (`packer-data-science-002`) and automatically update the image. -->
* **What session do we need to log into the Workspace VM?**
    * The local account to use can be found [here](./cloudbuild/foundation/packer-researcher-vm.yaml#L140) and password [here](./cloudbuild/foundation/packer-researcher-vm.yaml#L142)
* **How do I update the "golden" image the VM instances uses?**
    * The "golden" image is stored in the project called `image-factory`. When a researcher VM instance is created, the boot disk is pulled from the `image-factory`.
    * To update the "golden" image, this is all done through code located [here](./cloudbuild/foundation/packer-researcher-vm.yaml). A Cloud Build trigger called [{env}-researcher-vm-image](./environment/foundation/cloudbuild-sde/triggers-container.tf#L32) monitors for any change to the file and is fired when a change is pushed to the `main` branch.
* **How to change project default names?**
    * <u>Foundation</u>:
        * Image Factory: the default naming convention is `{env}-sde-image-factory`. To change or update go [here](./environment/foundation/image/main.tf#L50)
        * Data Ingress: the default naming convention is `{env}-sde-data-ingress`. To change or update go [here](./environment/foundation/data-ingress/main.tf#L46)
        * Data Ops: the default naming convention is `{env}-sde-data-ops`. To change or update go [here](./environment/foundation/data-ops/main.tf#L64).
        * Data Lake: the default naming convention is `{env}-sde-data-lake`. To change or update go [here](./environment/foundation/data-lake/main.tf#L64)
    * <u>Research Initiative</u>:
        * Egress: the default naming convention is `{env}-{dept label}-{project name}-egress`. To change or update go to the [variables.tf](./environment/deployments/researcher-projects/egress/variables.tf) file and update [dept label](./environment/deployments/researcher-projects/egress/variables.tf#L79) and/or [project name](./environment/deployments/researcher-projects/egress/variables.tf#L6). You can also use the `terraform.tfvars` file to override these values.
        * Workspace: the default naming convention is `{env}-{dept label}-{project name}-wrkspc`. To change or update go to the [variables.tf](./environment/deployments/researcher-projects/workspace/variables.tf) file and update [dept label](./environment/deployments/researcher-projects/workspace/variables.tf#L112) and/or [project name](./environment/deployments/researcher-projects/workspace/variables.tf#L6). You can also use the `terraform.tfvars` file to override these values.

* **Get an error when trying to RDP**
    ![](./docs/rdp-error-1.png)
    * When a new researcher initiative is created, a bucket with a login script is created in the `image-project`. Confirm this login script has been created.
    * On the local workstation, confirm the user is logged in with the correct permissions
    ```bash
    $ gcloud config list
    [accessibility]
    screen_reader = False
    [core]
    account = user@client.edu
    disable_usage_reporting = True
    project = prod-phi-init-wrkspc-a326

    Your active configuration is: [user-client]
    ```
    * Confirm the VM instance is in a running state.
    ```bash
    gcloud compute instances list --project prod-clientit-init-wrkspc-5e4d
    NAME                             ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP  STATUS
    gcp-sde-test-deep-learning-vm-0  us-central1-b  n2-standard-2               10.20.0.2                 RUNNING
    ```
    * Bypass the login script and use the following commands:
    ```bash
    # Create an IAP tunnel opening local port 3333
    $ gcloud beta compute start-iap-tunnel project-x-deep-learning-vm-0 3389 --local-host-port=localhost:3333 --zone=us-central1-b 

    # Open up RDP with port 3333
    $ mstsc /v:localhost:3333
    ```

* **How to mount the local researcher bucket with GCSFuse?**
    1. From the researcher VM instance, at a command prompt list the bucket:
        ```bash
        $ gsutil ls
        $ gs://sde-prod-us-central-shard-aaaa/
        ```
    1. Mount the local GCS bucket to the VM instance:
        ```bash
        # Create a mount point
        $ mkdir my-bucket

        # Use GCSFuse to mount bucket to a mount point
        $ gcsfuse sde-prod-us-central-shard-aaaa my-bucket
        ```
    1. After the local researcher bucket has been mounted, you'll see there is a `README.md` that's provided. The document provides the bucket name located in the Data-Lake project. Now mount the Data-Lake:
        ```bash
        # Create another mount point
        $ mkdir my-datalake

        #use GCSFuse to mount the bucket to a mount point
        $ gcsfuse --implicit-dirs gcs-us-central1-<researcher-initiative>-bbbb my-datalake
        ```
        >Note: By default, gcsfuse has no allowance for the implicit existance of directories. `--implicit-dirs` helps change this behavior. This behavior is document [here](https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/semantics.md#implicit-directories).
    1. Confirm the desired GCS buckets have been mounted by running `df -h`:
        ```bash
        $ df -h

        Filesystem                          Size    Used    Avail   Use%    Mounted on
        /dev/root                           97G     17G     81G     17%     /
        ...
        sde-prod-us-central-shared-aaaa     1.0P    0       1.0P    0%  /home/clientadmin/my-bucket
        gcs-us-central1-<init>-bbbb         1.0P    0       1.0P    0%  /home/clientadmin/my-datalake
        ```

* **How to add users to Cloud Composer (Apache Airflow)**
    
    [*Original document can be found here*](https://cloud.google.com/composer/docs/airflow-rbac#registering-users)

    1. Go to the Environments page in the Google Cloud console
    1. Select the `Airflow` web link below Airflow webserver. This will launch a new tab and open up the Airflow Console UI.
    1. From the Airflow Console UI > Select **Security** > **List Users**
    1. Select the [ + ] icon to add a new user record.
    1. Set the username field to the user's primary email address.
    1. Under roles, assign `Admin` role.
    1. Click Save.
    >**Note**: When a user with an email address matching a preregistered user record logs in to Airflow UI for the first time, their username is replaced with the user ID currently (at the time of first login) identified by their email address. The relationship between Google identities (email addresses) and user accounts (user IDs) is not fixed. Google groups cannot be preregistered.

* **How to ugprade Cloud Composer**

    To upgrade Cloud Composer update the [image_version](./environment/foundation/data-ops/cloud-composer/variables.tf#L49) variable to the desired version. The latest Cloud Composer images are found [here](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions).

    ### Example

    To upgrade from `composer-1.20.2-airflow-1.10.15` to `composer-1.20.7-airflow-1.10.15` change the default value.

    ```diff
    variable "image_version" {
    description = "The version of Airflow running in the Cloud Composer environment. Latest version found [here](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions)."
    type        = string
    - default     = "composer-1.20.2-airflow-1.10.15"
    + default     = "composer-1.20.7-airflow-1.10.15"
    }
    ```