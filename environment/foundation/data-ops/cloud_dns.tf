locals {
  restricted_api_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["restricted.googleapis.com."]
    },
    {
      name = "restricted"
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  artifact_registry_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["pkg.dev."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  container_registry_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  composer_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["composer.cloud.google.com."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]

  cloud_functions_cloud_dns_recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["cloudfunctions.net."]
    },
    {
      name = ""
      type = "A"
      ttl  = 300
      records = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7"
      ]
    }
  ]
}

module "cloud_dns_restricted_api" {
  # This private zone is used to access the restricted Google APIs
  source = "../../../modules/cloud_dns"

  cloud_dns_domain     = "googleapis.com."
  cloud_dns_name       = "restricted-google-apis"
  cloud_dns_project_id = module.secure-staging-project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone for mapping calls for restricted.googleapis.com to Virtual IP addresses in the SDE."
  private_visibility_config_networks = [module.vpc.network_self_link]
  cloud_dns_recordsets               = local.restricted_api_cloud_dns_recordsets
}

module "cloud_dns_artifact_registry" {
  # This private zone is used to access the Artifact Registry
  source = "../../../modules/cloud_dns"

  cloud_dns_domain     = "pkg.dev."
  cloud_dns_name       = "artifact-registry-zone"
  cloud_dns_project_id = module.secure-staging-project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Artifact Registry domain."
  private_visibility_config_networks = [module.vpc.network_self_link]
  cloud_dns_recordsets               = local.artifact_registry_cloud_dns_recordsets
}

module "cloud_dns_container_registry" {
  # This private zone is used to access Container Registry
  source = "../../../modules/cloud_dns"

  cloud_dns_domain     = "gcr.io."
  cloud_dns_name       = "container-registry-zone"
  cloud_dns_project_id = module.secure-staging-project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Container Registry domain."
  private_visibility_config_networks = [module.vpc.network_self_link]
  cloud_dns_recordsets               = local.container_registry_cloud_dns_recordsets
}

module "cloud_dns_composer" {
  # This private zone is used to access Composer.cloud
  source = "../../../modules/cloud_dns"

  cloud_dns_domain     = "composer.cloud.google."
  cloud_dns_name       = "cloud-composer-zone"
  cloud_dns_project_id = module.secure-staging-project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Cloud Composer domain."
  private_visibility_config_networks = [module.vpc.network_self_link]
  cloud_dns_recordsets               = local.composer_cloud_dns_recordsets
}

module "cloud_dns_cloud_function" {
  # This private zone is used to access Composer.cloud
  source = "../../../modules/cloud_dns"

  cloud_dns_domain     = "cloudfunctions.net."
  cloud_dns_name       = "cloud-functions-zone"
  cloud_dns_project_id = module.secure-staging-project.project_id
  cloud_dns_zone_type  = "private"

  cloud_dns_description              = "Private DNS Zone that enables access to Cloud Functions."
  private_visibility_config_networks = [module.vpc.network_self_link]
  cloud_dns_recordsets               = local.cloud_functions_cloud_dns_recordsets
}