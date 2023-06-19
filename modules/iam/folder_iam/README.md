# Terraform Module for Provisioning Folder Level IAM Roles

The purpose of this directory is to provision IAM roles for a defined account, groups, or domain at the folder level.

## Usage

Below is an example of how to use this module.

```terraform
module "folder_iam_member" {
    source = "./modules/iam/folder_iam"

    folder_id       = "<FOLDER_ID>"
    iam_role_list   = "roles/browser"
    folder_member   = "user:<USER_EMAIL>"
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_folder_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| folder\_id | The ID of the Folder to associate IAM roles and members. | `string` | `""` | no |
| folder\_member | The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}. | `string` | `""` | no |
| iam\_role\_list | The IAM role(s) to assign to the member at the defined folder. | `list(string)` | `[]` | no |

## Outputs

No output.