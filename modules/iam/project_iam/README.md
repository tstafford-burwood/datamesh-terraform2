# Terraform Module for Provisioning Project Level IAM Roles

The purpose of this directory is to provision IAM roles for a defined account, groups, or domain at the project level.

## Usage

Below is an example of how to use this module.

```terraform
module "project_iam_member" {
    source = "./modules/iam/project_iam"

    project_id            = "project1234"
    project_member        = "user:<USER_EMAIL>"
    project_iam_role_list = "roles/browser"
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_project_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_iam\_role\_list | The IAM role(s) to assign to the member at the defined project. | `list(string)` | `[]` | no |
| project\_id | The project ID where IAM roles and members will be set at. | `string` | `""` | no |
| project\_member | The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}. | `string` | `""` | no |

## Outputs

No output.