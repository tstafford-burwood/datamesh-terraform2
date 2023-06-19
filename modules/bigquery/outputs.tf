#------------------
# BIGQUERY OUTPUTS
#------------------

output "bigquery_dataset" {
  description = "Bigquery dataset resource."
  value       = module.bigquery.bigquery_dataset
}

output "bigquery_tables" {
  description = "Map of bigquery table resources being provisioned."
  value       = module.bigquery.bigquery_tables
}

output "bigquery_views" {
  description = "Map of bigquery view resources being provisioned."
  value       = module.bigquery.bigquery_views
}

output "bigquery_external_tables" {
  description = "Map of BigQuery external table resources being provisioned."
  value       = module.bigquery.bigquery_external_tables
}

output "project" {
  description = "Project where the dataset and tables are created."
  value       = module.bigquery.project
}

output "table_ids" {
  description = "Unique ID for the table being provisioned."
  value       = module.bigquery.table_ids
}

output "table_names" {
  description = "Friendly name for the table being provisioned."
  value       = module.bigquery.table_names
}

output "view_ids" {
  description = "Unique ID for the view being provisioned."
  value       = module.bigquery.view_ids
}

output "view_names" {
  description = "Friendly name for the view being provisioned."
  value       = module.bigquery.view_names
}

output "external_table_ids" {
  description = "Unique IDs for any external tables being provisioned."
  value       = module.bigquery.external_table_ids
}

output "external_table_names" {
  description = "Friendly names for any external tables being provisioned."
  value       = module.bigquery.external_table_names
}

output "routine_ids" {
  description = "Unique IDs for any routine being provisioned."
  value       = module.bigquery.routine_ids
}