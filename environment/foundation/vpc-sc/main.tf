locals {
  perimeter_members_data_ingestion = distinct(concat([
    "serviceAccount:${local.cloudbuild_service_account}",
    "serviceAccount:${local.composer_sa}",
    "serviceAccount:service-${local.data_ops}@compute-system.iam.gserviceaccount.com",
    "serviceAccount:${local.data_ops}@cloudbuild.gserviceaccount.com",
    "serviceAccount:service-${local.data_ops}@gcf-admin-robot.iam.gserviceaccount.com",
    "serviceAccount:${local.image_project_sa}",
  ], var.perimeter_additional_members, local.acclvl_sa, local.acclvl_stewards))

  base_restricted_services = [
    "bigquery.googleapis.com",
    "storage.googleapis.com"
  ]

  restricted_services = distinct(concat(local.base_restricted_services))
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "secure_imaging" {
  source = "../../../modules/vpc-sc"

  access_context_manager_policy_id = var.parent_access_policy_id
  common_name                      = "image_prj"
  common_suffix                    = random_id.suffix.hex
  resources = [
    local.image_project,
  ]

  perimeter_members   = local.perimeter_members_data_ingestion # users or service accounts
  restricted_services = ["run.googleapis.com", "bigquery.googleapis.com", "bigtable.googleapis.com", "sqladmin.googleapis.com", "pubsub.googleapis.com", "container.googleapis.com"]

  ingress_policies = [
    {
      "from" = {
        "sources" = {
          # allow any of the service accounts to to hit the listed APIs
          access_levels = ["*"]
        },
        "identity_type" = "ANY_SERVICE_ACCOUNT"
      }
      "to" = {
        "resources" = ["*"]
        "operations" = {
          "monitoring.googleapis.com" = {
            "methods" = ["*"]
          },
          "logging.googleapis.com" = {
            "methods" = ["*"]
          },
          "artifactregistry.googleapis.com" = {
            "methods" = ["*"]
          }
        }
      }
    },
  ]
}

module "secure_data" {
  source = "../../../modules/vpc-sc"

  access_context_manager_policy_id = var.parent_access_policy_id
  common_name                      = "data_enclave"
  common_suffix                    = random_id.suffix.hex
  resources = [
    local.data_ingress,
    local.data_ops,
    local.data_lake,
  ]

  perimeter_members   = local.perimeter_members_data_ingestion # users or service accounts
  restricted_services = local.restricted_services

  ingress_policies = [
    {
      "from" = {
        "sources" = {
          # allow any of the service accounts to to hit the listed APIs
          #access_levels = [module.access_level_service-accounts.name]
          access_levels = ["*"]
        },
        "identity_type" = "ANY_SERVICE_ACCOUNT"
      }
      "to" = {
        "resources" = ["*"]
        "operations" = {
          "container.googleapis.com" = {
            "methods" = ["*"]
          },
          "monitoring.googleapis.com" = {
            "methods" = ["*"]
          },
          "cloudfunctions.googleapis.com" = {
            "methods" = ["*"]
          },
          "artifactregistry.googleapis.com" = {
            "methods" = ["*"]
          },
          "compute.googleapis.com" = {
            "methods" = ["*"]
          },
          "storage.googleapis.com" = {
            "methods" = ["*"]
          }
        }
      }
    },
  ]

  egress_policies = [{
    "from" = {
      "identity_type" = "ANY_SERVICE_ACCOUNT"
      "identities"    = []
    },
    "to" = {
      "resources" = ["*"]
      "operations" = {
        "container.googleapis.com" = {
          "methods" = ["*"]
        },
        "monitoring.googleapis.com" = {
          "methods" = ["*"]
        },
        "cloudfunctions.googleapis.com" = {
          "methods" = ["*"]
        },
        "artifactregistry.googleapis.com" = {
          "methods" = ["*"]
        },
        "compute.googleapis.com" = {
          "methods" = ["*"]
        },
        "storage.googleapis.com" = {
          "methods" = ["*"]
        }
      }
    }
  }, ]
}