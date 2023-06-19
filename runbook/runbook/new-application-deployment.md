# Introduction

The [environment/deployment](../environment/deployments) directory is where all application code will be created and maintained.

# Provisioning New Projects

### Create a new git branch

1. Best practice for the process of starting a new application deployment would be to first create a feature branch from master.
1. If working through a CLI run `git checkout master` to switch into the `master` branch.
    1. Run `git checkout -b <new_branch_name_here>`.

### Create a Sub-Directory

1. Create a new sub-directory or copy from a pre-existing directory inside `environment/deployments`, use a consistent naming scheme from previous deployments. For example `group2-app`.

### Edit Terraform Code

1. Update Terraform code as needed to provision new and unique infrastructure. Generally the `.tfvars` files will be the ones that need to be updated since those contain variables with unique names such as `group1-app`, etc.

### Cloud Build Integration

1. Cloud Build YAML files will need to be created or copied as iterative projects are provisioned. For example `group2-app` should have YAML files for `group2` where the `dir` argument in the YAML has the path location specified to the `group2` Terraform files.

    ```diff
    id: 'terraform apply'
    name: 'hashicorp/terraform:${_TAG}'
    - dir: 'environment/deployments/group1-app'
    + dir: 'environment/deployments/group2-app'
    args: ['apply', 
        '-var-file=${_TFVARS}',
        '-auto-approve']
    ```

1. If a Cloud Build trigger was configured ahead of provisioning a new project then a Cloud Build run should start if the monitored file and branch are correctly setup.
1. If a Cloud Build trigger was not created first, then navigate to [runbook/cb-pipelines](./cb-pipelines.md) for instructions on setting up a pipeline. Afterwards run the pipeline manually through the Cloud Build UI.