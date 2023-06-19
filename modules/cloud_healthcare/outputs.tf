output "healthcare_dataset_id" {
  description = "An identifier for the resource."
  value       = [for id in google_healthcare_dataset.default : id.id]
}

output "healthcare_dataset" {
  description = "Full healtchare dataset resources"
  value       = google_healthcare_dataset.default
}

output "healthcare_dataset_self_link" {
  description = "The fully qualified name of this dataset."
  value       = [for sl in google_healthcare_dataset.default : sl.self_link]
}

output "fhir_datastore_id" {
  description = "An identifier for the FHIR datastore"
  value       = [for id in google_healthcare_fhir_store.default : id.id]
}

output "fhir_datastore_self_link" {
  description = "The fully qualified name of this fhir datastore."
  value       = [for selflink in google_healthcare_fhir_store.default : selflink.self_link]
}

output "hl7_datastore_id" {
  description = "An identifier for the HL7 datastore"
  value       = [for id in google_healthcare_hl7_v2_store.default : id.id]
}

output "hl7_datastore_self_link" {
  description = "The fully qualified name of this HL7 datastore."
  value       = [for selflink in google_healthcare_hl7_v2_store.default : selflink.self_link]
}