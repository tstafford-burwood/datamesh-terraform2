# Terraform Module for Provisioning a Custom IAM Role at the Project Level

The purpose of this directory is to provision a Custom IAM Role at the Project Level. This custom role can be used for specific needs based on the permission(s) set.

## Usage

Below is an example of how to use this module.

```terraform
module "project_iam_custom_role" {
    source = "./modules/iam/project_iam_custom_role"

    project_iam_custom_role_project_id  = "project1234"
    project_iam_custom_role_description = "Custom Role Description."
    project_iam_custom_role_id          = "myCustomRole"
    project_iam_custom_role_title       = "My Custom Role"
    project_iam_custom_role_permissions = ["storage.buckets.list"]
    project_iam_custom_role_stage       = "GA"
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_project_iam_custom_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_iam\_custom\_role\_description | A human-readable description for the role. | `string` | `"Custom role created with Terraform."` | no |       
| project\_iam\_custom\_role\_id | The camel case role id to use for this role. Cannot contain - characters. | `string` | `""` | no |
| project\_iam\_custom\_role\_permissions | The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified. | `list(string)` | `[]` | no |
| project\_iam\_custom\_role\_project\_id | The project that the custom role will be created in. Defaults to the provider project configuration. | `string` | `""` | no |
| project\_iam\_custom\_role\_stage | The current launch stage of the role. Defaults to GA. List of possible stages is [here](https://cloud.google.com/iam/docs/reference/rest/v1/organizations.roles#Role.RoleLaunchStage). | `string` | `""` | no |
| project\_iam\_custom\_role\_title | A human-readable title for the role. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | The name of the role in the format projects/{{project}}/roles/{{role\_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings. |