# Steps to build a new tenant

## Prerequirements

Confirm you're in the correct branch. In this repository, [separate Git repositories represent each environment](../../foundation/README.md).

`git remote -v` to check Git repo
`git checkout test` to check branch

### Build Steps

Below are the steps to creating new workspaces/tenants.

Create a new subfolder in the GCP hierarchy.
1. Navigate to the working directory: `cd ./environment/foundation/folders/env/`
1. Update the values below:
    ```diff
    - researcher_workspace_folders = ["workspace-1"]
    + researcher_workspace_folders = ["workspace-1", "tenant-1"]
    ```
1. `git add . -f`, `git commit -m "New tenant folder"`, `git push`
1. The `sde-workflow-foundation-apply` will be triggered and run.
    > A new trigger in Cloud Build will be created for this new tenant.

Create a new tenant
>Note: Prerequirement is the sub-folder must exist

1. Copy the template directory to a new directory. `cd ./environment/deployments/researcher-projects/env/`, `cp -R template/ tenant-1/`, `cd tenant-1`
    >Note: The directory name **MUST** match the value name given in the variable `researcher_workspace_folders`.
1. Update any of values in the `global.tfvars` file that are unique to the new tenant.
    ```diff
    - billing_account           = "AAAAAA-BBBBBB-CCCCCC"
    - researcher_workspace_name = "rare-disease"
    + billing_account           = "111111-222222-333333"
    + researcher_workspace_name = "payment"
    ```
1. Update any of the values in the `egress/terraform.tfvars` file.
    ```diff
    - project_users  = ["user:user1@example.com"] 
    + project_users  = ["group:tenant-group@example.com"] 
    ```
1. Update any of the values in the `workspace/terraform.tfvars` file.
    ```diff
    - researchers = ["user:user1@example.com"]
    + researchers = ["group:research-group@example.com"]
    ```
1. Save changes `git add . -f`
1. Add a comment to the changes `git commit -m "New tenant files"`
1. Push into the Git repo `git push`
1. The Cloud Build trigger associated with the new tenant will be triggered and ran.


## Destroy Steps

Remove the researcher projects (egress & workspace)
1. Go to [Cloud Build](https://console.cloud.google.com/cloud-build/triggers?project=prod-clientit-automation-21012) and duplicate the `apply` trigger associated with the tenant to destroy. Click the newly duplicated trigger and update the path for the **Cloud Build configuration file location** from `cloudbuild/deployments/researcher-workspace-project-apply.yaml` to `cloudbuild/deployments/researcher-workspace-project-destroy.yaml`. Click Save.
1. Manually run the new trigger and confirm the build completes successfully.
>**Note**: You will need to re-run the `destroy` trigger a number of times because of the timing of resources like destroying the VPC Service Controls needs time to propagate.

Update the hierarchy and triggers
1. `cd ./environment/foundation/folders/env/`
1. Remove the subfolder associated with the delete workspace
    ```diff
    - researcher_workspace_folders = ["workspace-1", "tenant-1"]
    + researcher_workspace_folders = ["workspace-1"]
    ```
1. `git add . -f`
1. `git commit -m "Remove tenant folder"`
1. `git push`
1. The `sde-workflow-foundation-apply` will be triggered and run.