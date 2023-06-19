#-----------------------------------
# PUB/SUB GCS NOTIFICATION VARIABLES
#-----------------------------------

// REQUIRED VARIABLES

variable "bucket_name" {
  description = "Name of the GCS bucket to setup notifications for."
  type        = string
  default     = ""
}

variable "payload_format" {
  description = "The desired content of the Payload. One of `JSON_API_V1` or `NONE`."
  type        = string
  default     = ""
}

variable "pub_sub_topic" {
  description = "The Cloud PubSub topic to which this subscription publishes. Expects either the topic name, assumed to belong to the default GCP provider project, or the project-level name, i.e. projects/my-gcp-project/topics/my-topic or my-topic. If the project is not set in the provider, you will need to use the project-level name."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "custom_attributes" {
  description = "A set of key/value attribute pairs to attach to each Cloud PubSub message published for this notification subscription."
  type        = map(string)
  default     = {}
}

variable "event_types" {
  description = "List of event type filters for this notification configuration. If not specified, Cloud Storage will send notifications for all event types. The valid types are: `OBJECT_FINALIZE`, `OBJECT_METADATA_UPDATE`, `OBJECT_DELETE`, `OBJECT_ARCHIVE`."
  type        = list(string)
  default     = []
}

variable "object_name_prefix" {
  description = "Specifies a prefix path filter for this notification config. Cloud Storage will only send notifications for objects in this bucket whose names begin with the specified prefix."
  type        = string
  default     = null
}