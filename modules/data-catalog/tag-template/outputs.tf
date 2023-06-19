output "id" {
  description = "Id of the resource"
  value       = google_data_catalog_tag_template.default.*.id
}

output "name" {
  description = "The resource name of the tag template in URL format"
  value       = google_data_catalog_tag_template.default.*.name
}