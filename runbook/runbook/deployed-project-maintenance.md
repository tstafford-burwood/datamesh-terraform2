# Introduction

This runbook is used to give a brief overview of how to update previously provisioned Terraform projects.

From a best practice approach:
1. Code changes should occur in a feature branch that is merged back into the master branch through a Pull Request approval process.
1. Cloud Build YAML files can have their `apply` step commented out so that only the `plan` step runs. After confirming `plan` output changes match up with what is expected, comment back in the `apply` step, and manually re-run the pipeline. This can be done if there is any concern of applying something through Terraform which may cause a break in functionality of a project or Organizational resource.

## General Steps of Project Maintenance

1. Navigate into the directory or sub-directory of the component that needs to be updated.
1. Edit the necessary files to update any infrastructure.
1. Commit changes back to a source repository; preferably through a Pull Request approval into the master branch.
    1. Certain tfvars values when edited may cause a new resource to provision, instead of an in-place update to occur. For instance editing a project's `name` would create a new project. 
    1. Editing a project's `labels` would create an in-place update of those labels only.
1. A Cloud Build run will start if the trigger was created for monitoring a certain branch and a certain file (for example a `.tfvars` file). More detail on this is outlined in [runbook/cb-pipelines.md](./cb-pipelines.md)
1. In the scenario where functionality from a new module or resource block is being added, those attributes would first be appended into the `main.tf` and `variables.tf` for that project.
    1. Add these variable fields into the associated project's `.tfvars` and commit back into a source repository. A Cloud Build run should start if the cloud Build trigger is properly setup.
    1. Otherwise a manual run of the pipeline can be started through the Cloud Build UI.

## Provision a module/resource into an existing project

1. This example will detail how to provision a module/resource into a pre-existing project.
1. Navigate to the `main.tf` in the project directory that needs to be updated.
1. Add source code of either the module or resource into the `main.tf`. The below example shows the addition of the `service_account` [module](../modules/service_account).

    ```diff
    #---------------------------
    # PROJECT LEVEL CONSTRAINTS
    #---------------------------

    module "uniform_bucket_level_access" {
      source      = "terraform-google-modules/org-policy/google"
      version     = "~> 3.0"
      project_id  = module.web-app-project-factory.project_id
      policy_for  = var.uniform_bucket_policy_for
      policy_type = var.uniform_bucket_policy_type
      enforce     = var.uniform_bucket_enforce
      constraint  = var.uniform_bucket_constraint
    }

    + module "service_account" {
    +    source  = "../../../../modules/service_account"
    +    version = "~> 3.0"
    +
    +    project_id         = var.project_id
    +    prefix             = var.prefix
    +    names              = var.names
    +    project_roles      = var.project_roles
    +    grant_billing_role = var.grant_billing_role
    +    billing_account_id = var.billing_account_id
    +    grant_xpn_roles    = var.grant_xpn_roles
    +    org_id             = var.org_id
    +    generate_keys      = var.generate_keys
    +    display_name       = var.display_name
    +    description        = var.description
    }
    ```
1. Add the appropriate variables from the module into the `variables.tf` of the working directory. Variable fields can also be added into the associated `.tfvars` file if they will be continually updated, such as `var.names` from the above example.
1. Commit code changes and create a Pull Request into the branch that has a Cloud Build pipeline monitoring the project.