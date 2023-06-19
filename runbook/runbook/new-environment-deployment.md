# Introduction

This runbook is used to give a brief overview of how to provision a new project environment (DEV, PROD, QA, etc.). For example going from a DEV web-app to a PROD web-app.

From a best practice approach:
1. Code changes should occur in a feature branch that is merged back into the master branch through a Pull Request approval process.

## Editing tfvars

1. The overall idea of creating new environments is through editing `tfvars` with regards to certain fields such as the project name and project label tfvar fields.

1. This will create a new project that has a naming scheme that can include `DEV`, `PROD`, etc.

1. In the [Deployments](../environment/deployments) directory create or copy the desired folder structure that will be used to provision a new environment. For example if there is a pre-existing `research-group1` directory and a `PROD` instance of that needs to be provisioned the pre-existing directory can be copied and the name can be updated as required.

1. Edit fields such as the `project_name`, `project_labels`, etc in order to reflect the project name, environment type, and group number or group name that needs to be provisioned.
    ```diff
    // PROJECT FACTORY
    - project_name          = "web-app-prod"
    + project_name          = "web-app2-prod"
    random_project_id     = true
    org_id                = "575228741867"
    high_risk_folder_id   = "627089312161"
    billing_account_id    = "01EF01-627C10-7CD2DF"
    project_labels = {
    "owner" : "uw",
    "application_name" : "web",
    "environment" : "prod",
    - "group" : "1"
    + "group" : "2"
    }
    ```
1. [Create Cloud Build triggers](./cb-pipelines.md) that are associated to this new sub-directory.

1. Commit code changes and create a Pull Request.

1. Monitor the status of the Cloud Build pipeline in the History section of the Cloud Build resource.