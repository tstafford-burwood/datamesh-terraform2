variable "project_id" {
  description = "The Project Id."
  type        = string
}

variable "dataset" {
  description = "The resource name of the Cloud Healthcare Dataset."
  type = map(object({
    region    = string #Location of the Healthcare Dataset.
    time_zone = string #Timezone. if null will default to UTC

  }))
}

variable "hl7_store" {
  type = map(object({
    dataset            = string
    allow_null_header  = string
    segment_terminator = string
    version            = string # Possible values are null, V1, V2, V3
  }))
  default = {}
}

variable "fhir_store" {
  description = "Create FHIR store."
  type = map(object({
    dataset                       = string
    version                       = string
    enable_update_create          = bool
    disable_referential_integrity = bool
    disable_resource_versioning   = bool
    enable_history_import         = bool
  }))
  default = {}
}

variable "fhir_store_labels" {
  description = "FHIR store labels"
  type        = map(any)
  default     = {}
}

variable "hl7_store_labels" {
  description = "HL7 store labels"
  type        = map(any)
  default     = {}
}