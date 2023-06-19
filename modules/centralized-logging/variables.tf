variable "random_project_id" {
  description = "Adds a suffix of 4 random characters to the `project_id`."
  type        = bool
  default     = true
}

variable "org_id" {
  description = "The organization ID."
  type        = string
}

variable "project_name" {
  description = "The name for the project"
  type        = string
  default     = "central-logging"
}

variable "project_id" {
  description = "The ID to give the project. If not provided, the `name` will be used."
  type        = string
  default     = ""
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
  type        = string
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
  default     = ""
}

variable "create_project_sa" {
  description = "Whether the default service account for the project shall be created"
  type        = bool
  default     = false
}

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "billingbudgets.googleapis.com",
    "pubsub.googleapis.com",
    "dataflow.googleapis.com"
  ]
}

variable "project_labels" {
  default = {}
}

variable "parent_resource_id" {
  description = "The ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc)."
  type        = string
}

variable "parent_resource_type" {
  description = "The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing_account', or 'organization'."
  type        = string
  default     = "folder"
}

variable "main_logs_filter" {
  description = "Main logs to filter"
  default     = <<EOF
    logName: /logs/cloudaudit.googleapis.com%2Factivity OR
    logName: /logs/cloudaudit.googleapis.com%2Fsystem_event OR
    logName: /logs/cloudaudit.googleapis.com%2Fdata_access OR
    logName: /logs/compute.googleapis.com%2Fvpc_flows OR
    logName: /logs/compute.googleapis.com%2Ffirewall OR
    logName: /logs/cloudaudit.googleapis.com%2Faccess_transparency
EOF
}

variable "all_logs_filter" {
  description = "All logs, no filter"
  default     = ""
}

variable "include_children" {
  description = "Only valid if 'organization' or 'folder' is chosen as var.parent_resource.type"
  type        = bool
  default     = true
}

/**************************
  GCS Storage Logs
**************************/

variable "create_gcs_logs_export" {
  description = "Create a Cloud Storage bucket for centralized logs"
  type        = bool
  default     = true
}

variable "log_sink_name_storage" {
  description = "Name of the sink for GCS Storage"
  type        = string
  default     = "sk-to-bkt-logs" # sink-to-bucket-logs
}

variable "storage_bucket_name" {
  description = "Name of the storage bucket that will store the logs."
  type        = string
  default     = "storage_example_bkt"
}

variable "dest_storage_location" {
  type    = string
  default = "us-central1"
}

variable "storage_class" {
  description = "The storage class of the storage bucket."
  type        = string
  default     = "STANDARD"
}

variable "storage_bucket_labels" {
  description = "Labels to apply to the storage bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  type = set(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = map(string)

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Comma delimited string for storage class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    # - days_since_custom_time - (Optional) The number of days from the Custom-Time metadata attribute after which this condition becomes true.
    condition = map(string)
  }))
  description = "List of lifecycle rules to configure. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches_storage_class should be a comma delimited string."
  default = [{
    action = {
      type = "Delete"
    }
    condition = {
      age        = 365
      with_state = "ANY"
    }
    },
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "COLDLINE"
      }
      condition = {
        age        = 180
        with_state = "ANY"
      }
  }]
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "versioning" {
  type    = bool
  default = false
}

/**************************
  BQ Logs
**************************/

variable "create_bq_logs_export" {
  description = "Create a BQ dataset for centralized logs"
  type        = bool
  default     = true
}

variable "bq_log_sink_name" {
  description = "Name of the sink for BQ"
  type        = string
  default     = "sk-to-dataset-logs"
}

variable "dataset_name" {
  description = "The name of the bigquery dataset to be created and used for log entries matching the filter."
  type        = string
  default     = "bq_folder"
}

variable "bq_dataset_description" {
  description = "A use-friendly description of the dataset"
  type        = string
  default     = "Log export dataset. Managed by Terraform."
}

variable "bq_location" {
  description = "The location of the storage bucket."
  type        = string
  default     = "us-central1"
}

variable "delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "expiration_days" {
  description = "Table expiration time. If unset logs will never be deleted."
  type        = number
  default     = 30
}

variable "partition_expiration_days" {
  description = "Partition expiration period in days. If both partition_expiration_days and expiration_days are not set, logs will never be deleted."
  type        = number
  default     = 30
}

/**************************
  Pub/Sub Logs
**************************/

variable "create_pubsub_logs_export" {
  description = "Create a BQ dataset for centralized logs"
  type        = bool
  default     = true
}

variable "pubsub_log_sink_name" {
  default = "sk-to-topic-logs"
}

variable "topic_name" {
  description = "The name of the pubsub topic to be created and used for log entries matching the filter."
  type        = string
  default     = "pubsub-folder"
}

variable "topic_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the pubsub topic."
}

variable "subscription_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the pubsub subscription."
}

variable "create_push_subscriber" {
  description = "Whether to add a push configuration to the subcription. If 'true', a push subscription is created for push_endpoint"
  type        = bool
  default     = false
}

/**************************
  Logs Bucket Logs
**************************/

variable "create_logsbucket_logs_export" {
  description = "Create a BQ dataset for centralized logs"
  type        = bool
  default     = true
}

variable "logsbucket_log_sink_name" {
  default = "sk-to-logbkt-logs"
}

variable "logsbucket_name" {
  type    = string
  default = "logbucket-folder"
}

variable "logsbucket_location" {
  type    = string
  default = "us-central1"
}

variable "logsbucket_retention_days" {
  description = "The number of days data should be retained for the log bucket."
  type        = number
  default     = 30
}

/**************************
  Splunk Logs
**************************/

variable "create_splunk_logs_export" {
  description = "Create a BQ dataset for centralized logs"
  type        = bool
  default     = false
}

variable "splunk_log_sink_name" {
  default = "sk-to-splunk-topic-logs"
}

variable "splunk_topic_name" {
  description = "The name of the pubsub topic to be created and used for log entries matching the filter."
  type        = string
  default     = "splunk-folder"
}

variable "splunk_topic_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the pubsub topic."
}

variable "splunk_subscription_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the pubsub subscription."
}

variable "splunk_create_push_subscriber" {
  description = "Whether to add a push configuration to the subcription. If 'true', a push subscription is created for push_endpoint"
  type        = bool
  default     = false
}