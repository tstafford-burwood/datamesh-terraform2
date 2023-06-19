#-----------------------
# CLOUD COMPOSER MODULE
#-----------------------

locals {
  network_project_id = var.network_project_id != "" ? var.network_project_id : var.project_id
  subnetwork_region  = var.subnetwork_region != "" ? var.subnetwork_region : join("-", slice(split("-", var.zone), 0, 2))
}

resource "google_composer_environment" "composer_env" {
  provider = google-beta
  project  = var.project_id
  name     = var.composer_env_name
  region   = var.region
  labels   = var.labels

  config {
    node_count = var.node_count

    node_config {
      zone            = var.zone
      machine_type    = var.gke_machine_type
      network         = "projects/${local.network_project_id}/global/networks/${var.network}"
      subnetwork      = "projects/${local.network_project_id}/regions/${local.subnetwork_region}/subnetworks/${var.subnetwork}"
      service_account = var.composer_service_account
      disk_size_gb    = var.disk_size
      oauth_scopes    = var.oauth_scopes
      tags            = var.tags

      dynamic "ip_allocation_policy" {
        for_each = var.use_ip_aliases ? [1] : []
        content {
          use_ip_aliases                = var.use_ip_aliases
          cluster_secondary_range_name  = var.pod_ip_allocation_range_name
          services_secondary_range_name = var.service_ip_allocation_range_name
        }
      }
    }

    dynamic "private_environment_config" {
      for_each = var.use_ip_aliases ? [
        {
          enable_private_endpoint    = var.enable_private_endpoint
          cloud_sql_ipv4_cidr_block  = var.cloud_sql_ipv4_cidr
          web_server_ipv4_cidr_block = var.web_server_ipv4_cidr
          master_ipv4_cidr_block     = var.master_ipv4_cidr
      }] : []
      content {
        enable_private_endpoint    = private_environment_config.value["enable_private_endpoint"]
        cloud_sql_ipv4_cidr_block  = private_environment_config.value["cloud_sql_ipv4_cidr_block"]
        web_server_ipv4_cidr_block = private_environment_config.value["web_server_ipv4_cidr_block"]
        master_ipv4_cidr_block     = private_environment_config.value["master_ipv4_cidr_block"]
      }
    }

    dynamic "software_config" {
      for_each = var.python_version != "" ? [
        {
          airflow_config_overrides = var.airflow_config_overrides
          env_variables            = var.env_variables
          image_version            = var.image_version
          pypi_packages            = var.pypi_packages
          python_version           = var.python_version
      }] : []
      content {
        airflow_config_overrides = software_config.value["airflow_config_overrides"]
        env_variables            = software_config.value["env_variables"]
        image_version            = software_config.value["image_version"]
        pypi_packages            = software_config.value["pypi_packages"]
        python_version           = software_config.value["python_version"]
      }
    }

    web_server_network_access_control {
      dynamic "allowed_ip_range" {
        for_each = var.allowed_ip_range
        content {
          value       = lookup(allowed_ip_range.value, "value", null)
          description = lookup(allowed_ip_range.value, "description", null)
        }
      }
    }

    database_config {
      machine_type = var.database_machine_type
    }

    web_server_config {
      machine_type = var.web_server_machine_type
    }

  }
}