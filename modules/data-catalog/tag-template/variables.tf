variable "project_id" {
  description = "GCP project id."
}

variable "tag_template_id" {
  description = "The ID of the tag template to create."
  type        = string
  default     = "my_template"
}

variable "region" {
  description = "Template location region."
  type        = string
  default     = "us-central1"
}

variable "display_name" {
  description = "The display name for this template."
  type        = string
  default     = "Demo Tag Template"
}


variable "force_delete" {
  description = "Deletion of any possible tags using this template. Must be set to `true` in order to delete the tag template."
  type        = bool
  default     = true
}

variable "fields" {
  description = "Used to create one or more typed fields."
  default     = []
  type = list(object({
    field_id       = string
    display_name   = string
    description    = string
    is_required    = bool
    primitive_type = string
    display_names  = list(string)
  }))
}