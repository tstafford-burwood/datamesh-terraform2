resource "google_healthcare_dataset" "default" {
  for_each = var.dataset

  project   = var.project_id
  name      = each.key
  location  = each.value.region
  time_zone = each.value.time_zone != null ? each.value.time_zone : null
}

resource "google_healthcare_fhir_store" "default" {
  for_each = var.fhir_store

  name    = each.key
  dataset = google_healthcare_dataset.default[each.value.dataset].id
  version = each.value.version == null ? "R4" : upper(each.value.version)

  # Set defaults for each value
  enable_update_create          = each.value.enable_update_create == null ? false : each.value.enable_update_create
  disable_referential_integrity = each.value.disable_referential_integrity == null ? false : each.value.disable_referential_integrity
  disable_resource_versioning   = each.value.disable_resource_versioning == null ? false : each.value.disable_resource_versioning
  enable_history_import         = each.value.enable_history_import == null ? false : each.value.enable_history_import

  labels = var.fhir_store_labels
}

resource "google_healthcare_hl7_v2_store" "default" {
  for_each = var.hl7_store

  name    = each.key
  dataset = google_healthcare_dataset.default[each.value.dataset].id

  parser_config {
    allow_null_header  = each.value.allow_null_header == null ? false : each.value.allow_null_header
    segment_terminator = each.value.segment_terminator == null ? null : each.value.segment_terminator
    version            = each.value.version == null ? "V1" : upper(each.value.version)
  }

  labels = var.hl7_store_labels
}