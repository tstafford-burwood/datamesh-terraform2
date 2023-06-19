# Terraform Directory for Constant Values

The purpose of this directory is to declare constant values that can be shared across projects in the Foundation directory and the Deployments directory. Values such as `org_id`, `billing_account_id`,`srd_folder_id`. 

## Usage

### Domain Information

The values under the Domain Information will be used across ALL projects in both Foundation folder and Deployment folder. Example is the same billing ID listed here, will be linked to ALL projects.

```hcl
# gcloud organizations list
org_id                     = 247721031950"                                
billing_account_id         = "0108A8-828C4A-C5572D"                       
sde_folder_id              = "0123456789" # parent folder id to place resources under
automation_project_id      = "tf-automation-example" # Project ID that has Cloud Build
cloudbuild_service_account = "<project_number>@cloudbuild.gserviceaccount.com"
terraform_state_bucket     = "tfstate-bucket-name" 
```

### Foundation User Groups

Any GCP project under the Foundation folder, the IAM roles for those projects can be controlled here using the the provided variables.

```hcl
// GROUPS TO ASSING TO FOUNDATION PROJECTS
image-project-admins = ["group:packer-image-team@example.com"]
data-lake-admins     = ["group:data-lake-admins@example.com"]
data-lake-viewers    = ["group:data-lake-viewers@example.com"]
data-ops-admins      = ["group:data-ops-admins@example.com"]
data-ops-stewards    = ["user:stewards1@example.com","user:stewards2@example.com"]
```

### Branches in Version Control Software

This application uses Terraform workspaces to control the deployment of different environments. Going forward, `environments` = `long-running-branches`

```hcl
environment = {
    # <branch_name> = <environment_value>
    dev  = "dev"
    test = "test"
    main = "prod"
}
```


<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description |
|---|---|
| [constants.tf](./constants.tf) | None |
| [outputs.tf](./outputs.tf) | Module outputs. |
| [variables.tf](./variables.tf) | Module variables. |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [value](outputs.tf#L5) | Reference output for accessing locals values in this directory. |  |  |

<!-- END TFDOC -->
