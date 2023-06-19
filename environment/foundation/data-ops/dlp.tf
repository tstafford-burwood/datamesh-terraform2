# ------------------------------------------
# DLP INSPECT TEMPLATE
# ------------------------------------------

resource "google_data_loss_prevention_inspect_template" "dlp_hipaa_inspect_template" {

  parent       = "projects/${module.secure-staging-project.project_id}/locations/${local.default_region}"
  description  = "Inspect Template - Terraform managed"
  display_name = "Basic HIPAA Inspect template"

  inspect_config {
    info_types {
      name = "CREDIT_CARD_NUMBER"
    }
    info_types {
      name = "EMAIL_ADDRESS"
    }
    info_types {
      name = "IP_ADDRESS"
    }
    info_types {
      name = "MAC_ADDRESS_LOCAL"
    }
    info_types {
      name = "MAC_ADDRESS"
    }
    info_types {
      name = "PHONE_NUMBER"
    }
    info_types {
      name = "US_INDIVIDUAL_TAXPAYER_IDENTIFICATION_NUMBER"
    }
    info_types {
      name = "US_SOCIAL_SECURITY_NUMBER"
    }
    info_types {
      name = "US_VEHICLE_IDENTIFICATION_NUMBER"
    }
    info_types {
      name = "PASSPORT"
    }
    info_types {
      name = "AGE"
    }
    info_types {
      name = "DATE"
    }
    info_types {
      name = "PERSON_NAME"
    }
    info_types {
      name = "SWIFT_CODE"
    }
    info_types {
      name = "DATE_OF_BIRTH"
    }
    info_types {
      name = "STREET_ADDRESS"
    }
    info_types {
      name = "ETHNIC_GROUP"
    }
    info_types {
      name = "US_DRIVERS_LICENSE_NUMBER"
    }
    info_types {
      name = "US_PASSPORT"
    }
    info_types {
      name = "US_PREPARER_TAXPAYER_IDENTIFICATION_NUMBER"
    }

    min_likelihood = "POSSIBLE"

  }
}

# ------------------------------------------
# DLP DE-ID TEMPLATE
# ------------------------------------------

resource "google_data_loss_prevention_deidentify_template" "basic" {

  parent       = "projects/${module.secure-staging-project.project_id}/locations/${local.default_region}"
  description  = "De-id Template - Terraform managed"
  display_name = "Basic HIPAA De-Id template"

  deidentify_config {
    info_type_transformations {

      transformations {
        info_types {
          name = "CREDIT_CARD_NUMBER"
        }
        info_types {
          name = "EMAIL_ADDRESS"
        }
        info_types {
          name = "IP_ADDRESS"
        }
        info_types {
          name = "MAC_ADDRESS_LOCAL"
        }
        info_types {
          name = "MAC_ADDRESS"
        }
        info_types {
          name = "PHONE_NUMBER"
        }
        info_types {
          name = "US_INDIVIDUAL_TAXPAYER_IDENTIFICATION_NUMBER"
        }
        info_types {
          name = "US_SOCIAL_SECURITY_NUMBER"
        }
        info_types {
          name = "US_VEHICLE_IDENTIFICATION_NUMBER"
        }
        info_types {
          name = "PASSPORT"
        }
        info_types {
          name = "AGE"
        }
        info_types {
          name = "DATE"
        }
        info_types {
          name = "PERSON_NAME"
        }
        info_types {
          name = "SWIFT_CODE"
        }
        info_types {
          name = "DATE_OF_BIRTH"
        }
        info_types {
          name = "STREET_ADDRESS"
        }
        info_types {
          name = "ETHNIC_GROUP"
        }
        info_types {
          name = "US_DRIVERS_LICENSE_NUMBER"
        }
        info_types {
          name = "US_PASSPORT"
        }
        info_types {
          name = "US_PREPARER_TAXPAYER_IDENTIFICATION_NUMBER"
        }

        primitive_transformation {
          replace_with_info_type_config = true
        }
      }
    }
  }
}

output "hipaa_inspect_template_id" {
  description = "The identifier for the resource."
  value       = google_data_loss_prevention_inspect_template.dlp_hipaa_inspect_template.id
}

output "hipaa_inspect_template_name" {
  description = "The resource name of the template"
  value       = google_data_loss_prevention_inspect_template.dlp_hipaa_inspect_template.name
}

output "hipaa_deid_template_id" {
  description = "The identifier for the resource."
  value       = google_data_loss_prevention_deidentify_template.basic.id
}

output "hipaa_deid_template_name" {
  description = "The resource name of the template"
  value       = google_data_loss_prevention_deidentify_template.basic.name
}