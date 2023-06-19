
resource "google_data_catalog_tag_template" "default" {
  project         = var.project_id
  tag_template_id = var.tag_template_id
  region          = var.region
  display_name    = var.display_name
  force_delete    = var.force_delete

  dynamic "fields" {

    for_each = toset(var.fields)

    content {
      field_id     = fields.value.field_id
      display_name = fields.value.display_name
      description  = fields.value.description
      is_required  = fields.value.is_required

      type {
        # the primitive_type and enum_type both CANNOT be set at the same time
        primitive_type = fields.value.primitive_type != null ? upper(fields.value.primitive_type) : ""

        dynamic "enum_type" {
          # Only one enum_type can be set
          for_each = fields.value.primitive_type == null ? [0] : []

          content {
            dynamic "allowed_values" {
              for_each = toset(fields.value.display_names)
              content {
                display_name = allowed_values.value
              }
            }
          }
        }
      }
    }
  }
}