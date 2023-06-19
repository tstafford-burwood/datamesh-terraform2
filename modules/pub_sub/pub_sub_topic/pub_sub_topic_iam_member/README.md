# Terraform Module for Provisioning Pub Sub Topic IAM Role Bindings

The purpose of this directory is to set one IAM role binding to one specified member which will be applied at the level of the Pub/Sub Topic. This is done at a 1:1 relationship of the role and member declaration.

## Usage

Below is an example of how to use this module.

module "pub_sub_topic_iam_binding" {
  source = "./modules/pub_sub/pub_sub_topic/pub_sub_topic_iam_member"

  // REQUIRED

  project_id = "project1234"
  topic_name = "my_topic"
  iam_member = "serviceAccount:my_service_account@domain.com"
  role       = "roles/pubsub.viewer"
}

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_pubsub_topic_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iam\_member | The member that will have the defined IAM role applied to. Refer [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam) for syntax of members. | `string` | `""` | no |
| project\_id | The Project ID that contains the Pub/Sub topic that will have a member and an IAM role applied to. | `string` | `""` | no |
| role | The IAM role to set for the member. Only one role can be set. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}` | `string` | `""` | no |
| topic\_name | The Pub/Sub Topic name. Used to find the parent resource to bind the IAM policy to. | `string` | `""` | no |

## Outputs

No output.