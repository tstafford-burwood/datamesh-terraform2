locals {
  project = format("%s-%s-%s", var.prefix, var.lbl_department, var.researcher_workspace_name)
  prefix  = substr(local.project, 0, 17)
}

module "workspace_project" {
  # Create project for researcher workspace
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name              = format("%s-%s", lower(local.prefix), "wrkspc")
  org_id            = local.org_id
  billing_account   = local.billing_account_id
  folder_id         = local.srde_folder_id
  random_project_id = true
  activate_apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "oslogin.googleapis.com",
    "iap.googleapis.com",
    "bigquery.googleapis.com",
    "dns.googleapis.com",
    "tpu.googleapis.com",
    "sourcerepo.googleapis.com",
    "osconfig.googleapis.com",
    "notebooks.googleapis.com",
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "sourcerepo.googleapis.com",
    "datacatalog.googleapis.com",
    "healthcare.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudasset.googleapis.com"
  ]
  default_service_account     = "delete"
  disable_dependent_services  = true
  disable_services_on_destroy = true
  create_project_sa           = false
  labels = {
    environment = var.prefix
  }
}

resource "google_compute_project_metadata" "researcher_workspace_project" {
  project = module.workspace_project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}

module "workspace_vpc" {
  # Create VPC and Subnetwork
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id                             = module.workspace_project.project_id
  network_name                           = format("%s-%s", local.researcher_workspace_name, "vpc")
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = true
  routing_mode                           = "GLOBAL"
  description                            = "Terraform managed"
  subnets = [
    {
      subnet_name               = "${local.researcher_workspace_name}-${local.region}-subnet-01"
      subnet_ip                 = "10.20.0.0/24"
      subnet_region             = local.region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]

  routes = local.workspace_vpc_routes

  firewall_rules = [
    {
      name        = "allow-ingress-rdp"
      description = "Firewall rule to allow traffic from IAP to RDP"
      priority    = 1000
      ranges      = ["35.235.240.0/20"]
      direction   = "INGRESS"

      allow = [
        {
          protocol = "tcp"
          ports    = ["3389", "22"]
        }
      ]
    },
    {
      name        = "allow-egress-google-managed-service"
      description = "Firewall rule to allow egress traffic to Google managed services"
      priority    = 2000
      ranges      = ["199.36.153.8/30", "199.36.153.4/30"]
      direction   = "EGRESS"

      allow = [
        {
          protocol = "all"
          ports    = null
        }
      ]
    },

    {
      name        = "deny-egress-all"
      description = "Firewall rule to deny all egress traffic"
      priority    = 64000
      ranges      = ["0.0.0.0/0"]
      direction   = "EGRESS"
      deny = [
        {
          protocol = "all"
          ports    = null
        }
      ]
    }
  ]
}