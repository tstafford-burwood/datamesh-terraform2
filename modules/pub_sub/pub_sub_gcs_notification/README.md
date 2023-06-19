# Terraform Module for Provisioning Google Cloud Storage Notifications

The purpose of this module is to setup Google Cloud Storage notifications that will be sent to a Pub/Sub topic from a defined GCS bucket. Notifications can be sent for GCS events such as `OBJECT_FINALIZE`, `OBJECT_METADATA_UPDATE`, `OBJECT_DELETE`, `OBJECT_ARCHIVE`

## Usage

Below is an example of how to use this module.

```terraform
module "gcs_pub_sub_notification" {
  source = "./modules/pub_sub/pub_sub_gcs_notification"

  // REQUIRED
  bucket_name    = "my_bucket"
  payload_format = "JSON_API_V1"
  pub_sub_topic  = "my_topic_to_send_notifications_to"

  // OPTIONAL
  custom_attributes  = {"key":"value"}
  event_types        = [OBJECT_FINALIZE, OBJECT_METADATA_UPDATE, OBJECT_DELETE, OBJECT_ARCHIVE]
  object_name_prefix = var.object_name_prefix
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_storage_notification](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name of the GCS bucket to setup notifications for. | `string` | `""` | no |
| custom\_attributes | A set of key/value attribute pairs to attach to each Cloud PubSub message published for this notification subscription. | `map(string)` | `{}` | no |
| event\_types | List of event type filters for this notification configuration. If not specified, Cloud Storage will send notifications for all event types. The valid types are: `OBJECT_FINALIZE`, `OBJECT_METADATA_UPDATE`, `OBJECT_DELETE`, `OBJECT_ARCHIVE`. | `list(string)` | `[]` | no |
| object\_name\_prefix | Specifies a prefix path filter for this notification config. Cloud Storage will only send notifications for objects in this bucket whose names begin with the specified prefix. | `string` | `null` | no |
| payload\_format | The desired content of the Payload. One of `JSON_API_V1` or `NONE`. | `string` | `""` | no |
| pub\_sub\_topic | The Cloud PubSub topic to which this subscription publishes. Expects either the topic name, assumed to belong to the default GCP provider project, or the project-level name, i.e. projects/my-gcp-project/topics/my-topic or my-topic. If the project is not set in the provider, you will need to use the project-level name. | `string` | `""` | no |

## Outputs

No output.