# Terraform Module for BigQuery

This module creates a BigQuery dataset and can grant roles to specific user accounts for access to that data.

## Usage

Here is an example of how to use this module.

```terraform
module "bigquery" {
  source                      = "terraform-google-modules/bigquery/google"
  version                     = "~> 4.4"
  dataset_id                  = "foo"
  dataset_name                = "bar"
  description                 = "some description"
  project_id                  = "<PROJECT_ID>"
  location                    = "US"
  default_table_expiration_ms = 3600000
  access                      = [
  {
    role                      = "OWNER"
    user_by_email             = "<ACCOUNT_EMAIL>"
  }

```

## Modules

| Name | Source | Version |
|------|--------|---------|
| bigquery | terraform-google-modules/bigquery/google | ~> 5.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bigquery\_access | An array of objects that define dataset access for one or more entities. | `any` | <pre>[<br>  {<br>    "group_by_email": "",<br> "role": "roles/bigquery.dataOwner"<br>  }<br>]</pre> | no |
| bigquery\_deletion\_protection | Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail. | `bool` | `false` | no |
| bigquery\_description | Bigquery dataset description. | `string` | `""` | no |
| dataset\_id | Unique ID for the dataset being provisioned. | `string` | `""` | no |
| dataset\_labels | Key value pairs in a map for dataset labels. | `map(string)` | `{}` | no |
| dataset\_name | Friendly name for the dataset being provisioned. | `string` | `""` | no |
| default\_table\_expiration\_ms | TTL of tables using the dataset in milliseconds. | `number` | `null` | no |
| delete\_contents\_on\_destroy | If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `true` | no |
| encryption\_key | Default encryption key to apply to the dataset. Defaults to null (Google-managed). | `string` | `null` | no |
| external\_tables | A list of objects which include table\_id, expiration\_time, external\_data\_configuration, and labels. | <pre>list(object({<br> table_id = string,<br> autodetect = bool,<br> compression = string,<br> ignore_unknown_values = bool,<br> max_bad_records = number,<br> schema = string,<br> source_format = string,<br> source_uris = list(string),<br> csv_options = object({<br> quote = string,<br> allow_jagged_rows = bool,<br> allow_quoted_newlines = bool,<br> encoding  = string,<br> field_delimiter = string,<br> skip_leading_rows = number,<br> }),<br> google_sheets_options = object({<br> range = string,<br> skip_leading_rows = number,<br> }),<br> hive_partitioning_options = object({<br> mode = string,<br> source_uri_prefix = string,<br> }),<br> expiration_time = string,<br> labels = map(string),<br>  }))</pre> | `[]` | no |
| location | The regional location for the dataset. Only US and EU are allowed in module. | `string` | `""` | no |
| project\_id | Project where the dataset and table are created. | `string` | `""` | no |
| routines | A list of objects which include routine\_id, routine\_type, routine\_language, definition\_body, return\_type, routine\_description and arguments. | <pre>list(object({<br> routine_id = string,<br> routine_type = string,<br> language = string,<br> definition_body = string,<br> return_type  = string,<br> description  = string,<br> arguments = list(object({<br>name = string,<br>data_type  = string,<br>argument_kind = string,<br>mode = string,<br> })),<br>  }))</pre> | `[]` | no |
| tables | A list of objects which include table\_id, schema, clustering, time\_partitioning, range\_partitioning, expiration\_time and labels. | <pre>list(object({<br> table_id= string,<br> schema  = string,<br> clustering = list(string),<br> time_partitioning = object({<br>expiration_ms= string,<br>field  = string,<br>type= string,<br>require_partition_filter = bool,<br> }),<br> range_partitioning = object({<br>field = string,<br>range = object({<br>  start = string,<br> end = string,<br>  interval = string,<br>}),<br> }),<br> expiration_time = string,<br> labels = map(string),<br>  }))</pre> | `[]` | no |
| views | A list of objects which include table\_id, which is view id, and view query. | <pre>list(object({<br> view_id  = string,<br> query = string,<br> use_legacy_sql = bool,<br> labels= map(string),}))<br> </pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| bigquery\_dataset | Bigquery dataset resource. |
| bigquery\_external\_tables | Map of BigQuery external table resources being provisioned. |
| bigquery\_tables | Map of bigquery table resources being provisioned. |
| bigquery\_views | Map of bigquery view resources being provisioned. |
| external\_table\_ids | Unique IDs for any external tables being provisioned. |
| external\_table\_names | Friendly names for any external tables being provisioned. |
| project | Project where the dataset and tables are created. |
| routine\_ids | Unique IDs for any routine being provisioned. |
| table\_ids | Unique ID for the table being provisioned. |
| table\_names | Friendly name for the table being provisioned. |
| view\_ids | Unique ID for the view being provisioned. |
| view\_names | Friendly name for the view being provisioned. |