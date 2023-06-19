# Terraform Module for Service Accounts

The purpose of this directory is to provision a custom service account and assign any desired project roles to that account.

## Usage

Below is an example of how to use this module.

```terraform
module "service_account" {

  source  = "./modules/service_account"

  // REQUIRED

  project_id = "project1234"

  // OPTIONAL
  
  billing_account_id    = var.billing_account_id
  description           = "Service account created with Terraform"
  display_name          = "my_service_account"
  generate_keys         = false
  grant_billing_role    = false
  grant_xpn_roles       = false
  service_account_names = ["my_service_account"]
  org_id                = var.org_id
  prefix                = "my_prefix"
  project_roles      = [
    "<PROJECT_NAME> => roles/viewer",
    "<PROJECT_NAME> => roles/storage.objectViewer",
  ]
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| service_account | terraform-google-modules/service-accounts/google | ~> 4.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account\_id | The ID of the billing account to associate this project with | `string` | `""` | no |
| description | Descriptions of the created service accounts (defaults to no description) | `string` | `""` | no |
| display\_name | Display names of the created service accounts (defaults to 'Terraform-managed service account') | `string` | `"Terraform-managed service account"` | no |
| generate\_keys | Generate keys for service accounts. | `bool` | `false` | no |
| grant\_billing\_role | Grant billing user role. | `bool` | `false` | no |
| grant\_xpn\_roles | Grant roles for shared VPC management. | `bool` | `false` | no |
| org\_id | The organization ID. | `string` | `""` | no |
| prefix | Prefix applied to service account names. | `string` | `""` | no |
| project\_id | The project ID to associate the service account to | `string` | `""` | no |
| project\_roles | Common roles to apply to all service accounts, project=>role as elements. | `list(string)` | `[]` | no |
| service\_account\_names | Names of the service accounts to create. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| email | The service account email. |
| iam\_email | The service account IAM-format email. |
| service\_account | Service account resource (for single use). |
| service\_accounts | Service account resources as list. |