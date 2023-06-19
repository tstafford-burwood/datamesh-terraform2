#-------------------------
# PUB/SUB TOPIC VARIABLES
#-------------------------

// REQUIRED VARIABLES

variable "topic_name" {
  description = "Name of the topic."
  type        = string
  default     = ""
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
  default     = ""
}

variable "allowed_persistence_regions" {
  description = "A list of IDs of GCP regions where messages that are published to the topic may be persisted in storage. Messages published by publishers running in non-allowed GCP regions (or running outside of GCP altogether) will be routed for storage in one of the allowed regions. An empty list means that no regions are allowed, and is not a valid configuration."
  type        = list(string)
}

// OPTIONAL VARIABLES

# variable "encoding" {
#   description = "The encoding of messages validated against schema. Default value is ENCODING_UNSPECIFIED. Possible values are ENCODING_UNSPECIFIED, JSON, and BINARY."
#   type        = string
#   default     = "ENCODING_UNSPECIFIED"
# }

variable "kms_key_name" {
  description = "The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. Your project's PubSub service account `(service-{{PROJECT_NUMBER}}@gcp-sa-pubsub.iam.gserviceaccount.com)` must have `roles/cloudkms.cryptoKeyEncrypterDecrypter` to use this feature. The expected format is `projects/*/locations/*/keyRings/*/cryptoKeys/*`"
  type        = string
  default     = null
}

variable "topic_labels" {
  description = "A set of key/value label pairs to assign to this Topic."
  type        = map(string)
  default     = {}
}

# variable "schema" {
#   description = "The name of the schema that messages published should be validated against. Format is projects/{project}/schemas/{schema}. The value of this field will be deleted-schema if the schema has been deleted."
#   type        = string
#   default     = ""
# }