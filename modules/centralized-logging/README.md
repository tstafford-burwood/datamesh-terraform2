
<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [billing_account](variables.tf#L24) | The ID of the billing account to associate this project with | <code>string</code> | ✓ |  |
| [org_id](variables.tf#L7) | The organization ID. | <code>string</code> | ✓ |  |
| [parent_resource_id](variables.tf#L59) | The ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc). | <code>string</code> | ✓ |  |
| [activate_apis](variables.tf#L41) | The list of apis to activate within the project | <code>list&#40;string&#41;</code> |  | <code title="&#91;&#10;  &#34;compute.googleapis.com&#34;,&#10;  &#34;storage.googleapis.com&#34;,&#10;  &#34;logging.googleapis.com&#34;,&#10;  &#34;bigquery.googleapis.com&#34;,&#10;  &#34;billingbudgets.googleapis.com&#34;,&#10;  &#34;pubsub.googleapis.com&#34;,&#10;  &#34;dataflow.googleapis.com&#34;&#10;&#93;">&#91;&#8230;&#93;</code> |
| [all_logs_filter](variables.tf#L82) | All logs, no filter | <code></code> |  |  |
| [bq_dataset_description](variables.tf#L202) | A use-friendly description of the dataset | <code>string</code> |  | <code>&#34;Log export dataset. Managed by Terraform.&#34;</code> |
| [bq_location](variables.tf#L208) | The location of the storage bucket. | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |
| [bq_log_sink_name](variables.tf#L190) | Name of the sink for BQ | <code>string</code> |  | <code>&#34;sk-to-dataset-logs&#34;</code> |
| [create_bq_logs_export](variables.tf#L184) | Create a BQ dataset for centralized logs | <code>bool</code> |  | <code>true</code> |
| [create_gcs_logs_export](variables.tf#L97) | Create a Cloud Storage bucket for centralized logs | <code>bool</code> |  | <code>true</code> |
| [create_logsbucket_logs_export](variables.tf#L274) | Create a BQ dataset for centralized logs | <code>bool</code> |  | <code>true</code> |
| [create_project_sa](variables.tf#L35) | Whether the default service account for the project shall be created | <code>bool</code> |  | <code>false</code> |
| [create_pubsub_logs_export](variables.tf#L236) | Create a BQ dataset for centralized logs | <code>bool</code> |  | <code>true</code> |
| [create_push_subscriber](variables.tf#L264) | Whether to add a push configuration to the subcription. If 'true', a push subscription is created for push_endpoint | <code>bool</code> |  | <code>false</code> |
| [create_splunk_logs_export](variables.tf#L304) | Create a BQ dataset for centralized logs | <code>bool</code> |  | <code>false</code> |
| [dataset_name](variables.tf#L196) | The name of the bigquery dataset to be created and used for log entries matching the filter. | <code>string</code> |  | <code>&#34;bq_folder&#34;</code> |
| [delete_contents_on_destroy](variables.tf#L214) | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | <code>bool</code> |  | <code>true</code> |
| [dest_storage_location](variables.tf#L115) |  | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |
| [expiration_days](variables.tf#L220) | Table expiration time. If unset logs will never be deleted. | <code>number</code> |  | <code>30</code> |
| [folder_id](variables.tf#L29) | The ID of a folder to host this project | <code>string</code> |  | <code>&#34;&#34;</code> |
| [force_destroy](variables.tf#L170) |  | <code>bool</code> |  | <code>true</code> |
| [include_children](variables.tf#L87) | Only valid if 'organization' or 'folder' is chosen as var.parent_resource.type | <code>bool</code> |  | <code>true</code> |
| [lifecycle_rules](variables.tf#L132) | List of lifecycle rules to configure. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches_storage_class should be a comma delimited string. | <code title="set&#40;object&#40;&#123;&#10;  action &#61; map&#40;string&#41;&#10;  condition &#61; map&#40;string&#41;&#10;&#125;&#41;&#41;">set&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code title="&#91;&#123;&#10;  action &#61; &#123;&#10;    type &#61; &#34;Delete&#34;&#10;  &#125;&#10;  condition &#61; &#123;&#10;    age        &#61; 365&#10;    with_state &#61; &#34;ANY&#34;&#10;  &#125;&#10;  &#125;,&#10;  &#123;&#10;    action &#61; &#123;&#10;      type          &#61; &#34;SetStorageClass&#34;&#10;      storage_class &#61; &#34;COLDLINE&#34;&#10;    &#125;&#10;    condition &#61; &#123;&#10;      age        &#61; 180&#10;      with_state &#61; &#34;ANY&#34;&#10;    &#125;&#10;&#125;&#93;">&#91;&#123;&#8230;&#125;&#93;</code> |
| [log_sink_name_storage](variables.tf#L103) | Name of the sink for GCS Storage | <code>string</code> |  | <code>&#34;sk-to-bkt-logs&#34; &#35; sink-to-bucket-logs&#34;</code> |
| [logsbucket_location](variables.tf#L289) |  | <code>string</code> |  | <code>&#34;us-central1&#34;</code> |
| [logsbucket_log_sink_name](variables.tf#L280) |  | <code></code> |  | <code>sk-to-logbkt-logs</code> |
| [logsbucket_name](variables.tf#L284) |  | <code>string</code> |  | <code>&#34;logbucket-folder&#34;</code> |
| [logsbucket_retention_days](variables.tf#L294) | The number of days data should be retained for the log bucket. | <code>number</code> |  | <code>30</code> |
| [main_logs_filter](variables.tf#L70) | Main logs to filter | <code></code> |  | <code title="&#60;&#60;EOF&#10;  logName: &#47;logs&#47;cloudaudit.googleapis.com&#37;2Factivity OR&#10;  logName: &#47;logs&#47;cloudaudit.googleapis.com&#37;2Fsystem_event OR&#10;  logName: &#47;logs&#47;cloudaudit.googleapis.com&#37;2Fdata_access OR&#10;  logName: &#47;logs&#47;compute.googleapis.com&#37;2Fvpc_flows OR&#10;  logName: &#47;logs&#47;compute.googleapis.com&#37;2Ffirewall OR&#10;  logName: &#47;logs&#47;cloudaudit.googleapis.com&#37;2Faccess_transparency&#10;F">&#60;&#60;EOF&#8230;EOF</code> |
| [parent_resource_type](variables.tf#L64) | The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing_account', or 'organization'. | <code>string</code> |  | <code>&#34;folder&#34;</code> |
| [partition_expiration_days](variables.tf#L226) | Partition expiration period in days. If both partition_expiration_days and expiration_days are not set, logs will never be deleted. | <code>number</code> |  | <code>30</code> |
| [project_id](variables.tf#L18) | The ID to give the project. If not provided, the `name` will be used. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [project_labels](variables.tf#L55) |  | <code></code> |  | <code>&#123;&#125;</code> |
| [project_name](variables.tf#L12) | The name for the project | <code>string</code> |  | <code>&#34;central-logging&#34;</code> |
| [pubsub_log_sink_name](variables.tf#L242) |  | <code></code> |  | <code>sk-to-topic-logs</code> |
| [random_project_id](variables.tf#L1) | Adds a suffix of 4 random characters to the `project_id`. | <code>bool</code> |  | <code>true</code> |
| [splunk_create_push_subscriber](variables.tf#L332) | Whether to add a push configuration to the subcription. If 'true', a push subscription is created for push_endpoint | <code>bool</code> |  | <code>false</code> |
| [splunk_log_sink_name](variables.tf#L310) |  | <code></code> |  | <code>sk-to-splunk-topic-logs</code> |
| [splunk_subscription_labels](variables.tf#L326) | A set of key/value label pairs to assign to the pubsub subscription. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [splunk_topic_labels](variables.tf#L320) | A set of key/value label pairs to assign to the pubsub topic. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [splunk_topic_name](variables.tf#L314) | The name of the pubsub topic to be created and used for log entries matching the filter. | <code>string</code> |  | <code>&#34;splunk-folder&#34;</code> |
| [storage_bucket_labels](variables.tf#L126) | Labels to apply to the storage bucket. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [storage_bucket_name](variables.tf#L109) | Name of the storage bucket that will store the logs. | <code>string</code> |  | <code>&#34;storage_example_bkt&#34;</code> |
| [storage_class](variables.tf#L120) | The storage class of the storage bucket. | <code>string</code> |  | <code>&#34;STANDARD&#34;</code> |
| [subscription_labels](variables.tf#L258) | A set of key/value label pairs to assign to the pubsub subscription. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [topic_labels](variables.tf#L252) | A set of key/value label pairs to assign to the pubsub topic. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [topic_name](variables.tf#L246) | The name of the pubsub topic to be created and used for log entries matching the filter. | <code>string</code> |  | <code>&#34;pubsub-folder&#34;</code> |
| [versioning](variables.tf#L175) |  | <code>bool</code> |  | <code>false</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [destination_bq_name](outputs.tf#L30) | The resource name for the destination BQ. |  |
| [destination_logsbucket_name](outputs.tf#L64) | The resource name for the destination logsbucket. |  |
| [destination_pubsub_name](outputs.tf#L47) | The resource name for the destination Pub/Sub. |  |
| [destination_splunk_name](outputs.tf#L81) | The resource name for the destination logsbucket. |  |
| [destination_storage_name](outputs.tf#L13) | The resource name for the destination Storage. |  |
| [log_sink_resource_name_bq](outputs.tf#L20) | The resource name of the log sink that was created for BQ. |  |
| [log_sink_resource_name_logsbucket](outputs.tf#L54) | The resource name of the log sink that was created for logsbucket. |  |
| [log_sink_resource_name_pubsub](outputs.tf#L37) | The resource name of the log sink that was created for Pub/Sub. |  |
| [log_sink_resource_name_splunk](outputs.tf#L71) | The resource name of the log sink that was created for Splunk. |  |
| [log_sink_resource_name_storage](outputs.tf#L3) | The resource name of the log sink that was created. |  |
| [pubsub_subscripter_splunk](outputs.tf#L86) | Pub/Sub topic subscriber email |  |
| [pubsub_subscription_name_splunk](outputs.tf#L91) | Pub/Sub topic subscription name for Splunk |  |
| [pubsub_topic_name_splunk](outputs.tf#L96) | Pub/Sub topic name for Splunk |  |
| [writer_identity_bq](outputs.tf#L25) | The service account that logging uses to write log entries to the destination BQ. |  |
| [writer_identity_logsbucket](outputs.tf#L59) | The service account that logging uses to write log entries to the destination logsbucket. |  |
| [writer_identity_pubsub](outputs.tf#L42) | The service account that logging uses to write log entries to the destination Pub/Sub. |  |
| [writer_identity_splunk](outputs.tf#L76) | The service account that logging uses to write log entries to the destination logsbucket. |  |
| [writer_identity_storage](outputs.tf#L8) | The service account that logging uses to write log entries to the destination. |  |

<!-- END TFDOC -->
