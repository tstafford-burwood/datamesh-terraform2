# Terraform Module for Provisioning a Pub/Sub Topic

The purpose of this module is to provision a Pub/Sub topic with a specified name in a GCP project. Publishers in GCP will send messages to this topic.

**NOTE** The inputs for `schema` and `encoding` only work with provider of `google = "~> 3.68.0"`. The `schema` field needs to use a valid schema name and cannot be left with `""` or `null`.

## Usage

Below is a simple example of how to use this module.

```terraform
module "pub_sub_topic" {
  source = "./modules/pub_sub/pub_sub_topic"

  // REQUIRED

  topic_name                  = "my_topic_name"
  project_id                  = "project1234"
  allowed_persistence_regions = ["us-east4"]
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_pubsub_topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_persistence\_regions | A list of IDs of GCP regions where messages that are published to the topic may be persisted in storage. Messages published by publishers running in non-allowed GCP regions (or running outside of GCP altogether) will be routed for storage in one of the allowed regions. An empty list means that no regions are allowed, and is not a valid configuration. | `list(string)` | n/a | yes |
| kms\_key\_name | The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. Your project's PubSub service account `(service-{{PROJECT_NUMBER}}@gcp-sa-pubsub.iam.gserviceaccount.com)` must have `roles/cloudkms.cryptoKeyEncrypterDecrypter` to use this feature. The expected format is `projects/*/locations/*/keyRings/*/cryptoKeys/*` | `string` | `null` | no |
| project\_id | The ID of the project in which the resource belongs. | `string` | `""` | no |
| topic\_labels | A set of key/value label pairs to assign to this Topic. | `map(string)` | `{}` | no |
| topic\_name | Name of the topic. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| topic\_labels | Pub/Sub label as a key:value pair. |
| topic\_name | Pub/Sub topic name. |