#-------------------------------
# PUB/SUB SUBSCRIPTION VARIABLES
#-------------------------------

// REQUIRED VARIABLES

variable "subscription_name" {
  description = "Name of the subscription."
  type        = string
  default     = ""
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
  default     = ""
}

variable "subscription_topic_name" {
  description = "The name of the topic to reference and associate this subscription with."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "ack_deadline_seconds" {
  description = "This value is the maximum time after a subscriber receives a message before the subscriber should acknowledge the message. After message delivery but before the ack deadline expires and before the message is acknowledged, it is an outstanding message and will not be delivered again during that time (on a best-effort basis). For pull subscriptions, this value is used as the initial value for the ack deadline. To override this value for a given message, call subscriptions.modifyAckDeadline with the corresponding ackId if using pull. The minimum custom deadline you can specify is 10 seconds. The maximum custom deadline you can specify is 600 seconds (10 minutes). If this parameter is 0, a default value of 10 seconds is used. For push delivery, this value is also used to set the request timeout for the call to the push endpoint. If the subscriber never acknowledges the message, the Pub/Sub system will eventually redeliver the message."
  type        = number
  default     = 10
}

variable "audience" {
  description = "Audience to be used when generating OIDC token. The audience claim identifies the recipients that the JWT is intended for. The audience value is a single case-sensitive string. Having multiple values (array) for the audience field is not supported. More info about the OIDC JWT token audience [here](https://tools.ietf.org/html/rfc7519#section-4.1.3). Note: if not specified, the Push endpoint URL will be used."
  type        = string
  default     = null
}

variable "dead_letter_topic" {
  description = "The name of the topic to which dead letter messages should be published. Format is projects/{project}/topics/{topic}. The Cloud Pub/Sub service account associated with the enclosing subscription's parent project (i.e., service-{project_number}@gcp-sa-pubsub.iam.gserviceaccount.com) must have permission to Publish() to this topic. The operation will fail if the topic does not exist. Users should ensure that there is a subscription attached to this topic since messages published to a topic with no subscriptions are lost."
  type        = string
  default     = null
}

variable "enable_message_ordering" {
  description = "If `true`, messages published with the same orderingKey in PubsubMessage will be delivered to the subscribers in the order in which they are received by the Pub/Sub system. Otherwise, they may be delivered in any order."
  type        = bool
  default     = true
}

variable "expiration_policy_ttl" {
  description = "Specifies the `time-to-live` duration for an associated resource. The resource expires if it is not active for a period of ttl. If ttl is not set, the associated resource never expires. A duration in seconds with up to nine fractional digits, terminated by 's'. Example - `3.5s`."
  type        = string
  default     = ""
}

variable "filter" {
  description = "The subscription only delivers the messages that match the filter. Pub/Sub automatically acknowledges the messages that don't match the filter. You can filter messages by their attributes. The maximum length of a filter is 256 bytes. After creating the subscription, you can't modify the filter."
  type        = number
  default     = null
}

variable "maximum_backoff" {
  description = "The maximum delay between consecutive deliveries of a given message. Value should be between 0 and 600 seconds. Defaults to 600 seconds. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: `3.5`."
  type        = number
  default     = null
}

variable "minimum_backoff" {
  description = "The minimum delay between consecutive deliveries of a given message. Value should be between 0 and 600 seconds. Defaults to 10 seconds. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: `3.5s`."
  type        = number
  default     = null
}

variable "max_delivery_attempts" {
  description = "The maximum number of delivery attempts for any message. The value must be between 5 and 100. The number of delivery attempts is defined as 1 + (the sum of number of NACKs and number of times the acknowledgement deadline has been exceeded for the message). A NACK is any call to ModifyAckDeadline with a 0 deadline. Note that client libraries may automatically extend ack_deadlines. This field will be honored on a best effort basis. If this parameter is 0, a default value of 5 is used."
  type        = number
  default     = null
}

variable "message_retention_duration" {
  description = "How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published. If retainAckedMessages is true, then this also configures the retention of acknowledged messages, and thus configures how far back in time a subscriptions.seek can be done. Defaults to 7 days. Cannot be more than 7 days (`604800s`) or less than 10 minutes (`600s`). A duration in seconds with up to nine fractional digits, terminated by 's'. Example: `600.5s`."
  type        = number
  default     = null
}

variable "push_endpoint" {
  description = "A URL locating the endpoint to which messages should be pushed. For example, a Webhook endpoint might use `https://example.com/push`."
  type        = string
  default     = ""
}

variable "push_attributes" {
  description = "Endpoint configuration attributes. Every endpoint has a set of API supported attributes that can be used to control different aspects of the message delivery. The currently supported attribute is x-goog-version, which you can use to change the format of the pushed message. This attribute indicates the version of the data expected by the endpoint. This controls the shape of the pushed message (i.e., its fields and metadata). The endpoint version is based on the version of the Pub/Sub API. If not present during the subscriptions.create call, it will default to the version of the API used to make such call. If not present during a subscriptions.modifyPushConfig call, its value will not be changed. subscriptions.get calls will always return a valid version, even if the subscription was created without this attribute. The possible values for this attribute are: [v1beta1] - uses the push format defined in the v1beta1 Pub/Sub API OR [v1 or v1beta2] - uses the push format defined in the v1 Pub/Sub API."
  type        = map(string)
  default     = {}
}

variable "retain_acked_messages" {
  description = "Indicates whether to retain acknowledged messages. If `true`, then messages are not expunged from the subscription's backlog, even if they are acknowledged, until they fall out of the messageRetentionDuration window."
  type        = bool
  default     = false
}

variable "service_account_email" {
  description = " Service account email to be used for generating the OIDC token. The caller (for subscriptions.create, subscriptions.patch, and subscriptions.modifyPushConfig RPCs) must have the iam.serviceAccounts.actAs permission for the service account."
  type        = string
  default     = ""
}

variable "subscription_labels" {
  description = "A set of key/value label pairs to assign to this Subscription."
  type        = map(string)
  default     = {}
}