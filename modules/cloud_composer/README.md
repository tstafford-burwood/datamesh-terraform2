# Terraform Module for Cloud Composer

The purpose of this directory is to provision a Cloud Composer instance that is fully managed by GCP. Cloud Composer is used to orchestrate data workflows. The Airflow UI web server is where DAGs (directed acyclic graphs) are ran. DAGs define a data workflow. The Airflow web server also has the ability to limit access based on an allowed IP range that is defined in the tfvars file.

## Usage

Below is an example of how to use this module.

```tf
module "cloud_composer" {
  source = "./modules/cloud_composer"

  // REQUIRED
  composer_env_name = "private_composer_cluster"
  network           = "test-network"
  project_id        = "project123"
  subnetwork        = var.subnetwork

  // OPTIONAL
  airflow_config_overrides         = var.airflow_config_overrides
  allowed_ip_range                 = [
    {
      value = "X.X.X.X/1"
      description = "Test IP1"
    },
    {
      value = "X.X.X.X/2"
      description = "Test IP2"
    }
    ]
  cloud_sql_ipv4_cidr              = var.cloud_sql_ipv4_cidr
  composer_service_account         = var.composer_service_account
  database_machine_type            = "db-n1-standard-4"
  labels                           = var.labels
  gke_machine_type                 = var.gke_machine_type
  master_ipv4_cidr                 = var.master_ipv4_cidr
  node_count                       = var.node_count
  oauth_scopes                     = var.oauth_scopes
  pod_ip_allocation_range_name     = "<SECONDARY_RANGE_NAME>"
  pypi_packages                    = var.pypi_packages
  python_version                   = var.python_version
  region                           = var.region
  service_ip_allocation_range_name = var.service_ip_allocation_range_name
  tags                             = var.tags
  use_ip_aliases                   = true
  web_server_ipv4_cidr             = var.web_server_ipv4_cidr
  web_server_machine_type          = var.web_server_machine_type
  zone                             = var.zone

  // SHARED VPC SUPPORT
  network_project_id = var.network_project_id
  subnetwork_region  = var.subnetwork_region
}
```

## Requirements

| Name | Version |
|------|---------|
| google | ~> 3.65.0 |
| google-beta | ~> 3.65.0 |

## Providers

| Name | Version |
|------|---------|
| google-beta | ~> 3.65.0 |

## Resources

| Name |
|------|
| [google-beta_google_composer_environment](https://registry.terraform.io/providers/hashicorp/google-beta/3.65.0/docs/resources/google_composer_environment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| airflow\_config\_overrides | Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example "core-dags\_are\_paused\_at\_creation". | `map(string)` | `{}` | no |
| allowed\_ip\_range | The IP ranges which are allowed to access the Apache Airflow Web Server UI. | <pre>list(object({<br> value = string<br> description = string<br>  }))</pre> | `[]` | no |
| cloud\_sql\_ipv4\_cidr | The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. | `string` | `null` | no |
| composer\_env\_name | Name of Cloud Composer Environment | `string` | n/a | yes |
| composer\_service\_account | Service Account for running Cloud Composer. | `string` | `null` | no |
| database\_machine\_type | The machine type to setup for the SQL database in the Cloud Composer environment. | `string` | `"db-n1-standard-2"` | no |   
| disk\_size | The disk size in GB for nodes. | `string` | `"50"` | no |
| enable\_private\_endpoint | Configure the ability to have public access to the cluster endpoint. If private endpoint is enabled, connecting to the cluster will need to be done with a VM in the same VPC and region as the Composer environment. Additional details can be found [here](https://cloud.google.com/composer/docs/concepts/private-ip#cluster). | `bool` | `false` | no |
| env\_variables | Variables of the airflow environment. | `map(string)` | `{}` | no |
| gke\_machine\_type | Machine type of Cloud Composer GKE nodes. | `string` | `"n1-standard-1"` | no |
| image\_version | The version of Airflow running in the Cloud Composer environment. | `string` | `null` | no |
| labels | The resource labels (a map of key/value pairs) to be applied to the Cloud Composer. | `map(string)` | `{}` | no |
| master\_ipv4\_cidr | The CIDR block from which IP range in tenant project will be reserved for the master. | `string` | `null` | no |
| network | The VPC network to host the Composer cluster. | `string` | n/a | yes |
| network\_project\_id | The project ID of the shared VPC's host (for shared vpc support) | `string` | `""` | no |
| node\_count | Number of worker nodes in the Cloud Composer Environment. | `number` | `3` | no |
| oauth\_scopes | Google API scopes to be made available on all node. | `set(string)` | <pre>[<br>  "https://www.googleapis.com/auth/cloud-platform"<br>]</pre> | no |
| pod\_ip\_allocation\_range\_name | The name of the cluster's secondary range used to allocate IP addresses to pods. | `string` | `null` | no |
| project\_id | Project ID where Cloud Composer Environment is created. | `string` | n/a | yes |
| pypi\_packages | Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. "numpy"). | `map(string)` | `{}` | no |
| python\_version | The default version of Python used to run the Airflow scheduler, worker, and webserver processes. | `string` | `"3"` | no |
| region | Region where the Cloud Composer Environment is created. | `string` | `"us-central1"` | no |
| service\_ip\_allocation\_range\_name | The name of the services' secondary range used to allocate IP addresses to the cluster. | `string` | `null` | no |
| subnetwork | The subnetwork to host the Composer cluster. | `string` | n/a | yes |
| subnetwork\_region | The subnetwork region of the shared VPC's host (for shared vpc support) | `string` | `""` | no |
| tags | Tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls. | `set(string)` | `[]` | no |
| use\_ip\_aliases | Enable Alias IPs in the GKE cluster. If true, a VPC-native cluster is created. | `bool` | `false` | no |
| web\_server\_ipv4\_cidr | The CIDR block from which IP range in tenant project will be reserved for the web server. | `string` | `null` | no |
| web\_server\_machine\_type | The machine type to setup for the Apache Airflow Web Server UI. | `string` | `"composer-n1-webserver-2"` | no |
| zone | Zone where the Cloud Composer nodes are created. | `string` | `"us-central1-f"` | no |

## Outputs

| Name | Description |
|------|-------------|
| composer\_env\_id | ID of Cloud Composer Environment. |
| composer\_env\_name | Name of the Cloud Composer Environment. |
| gcs\_bucket | Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment. |
| gke\_cluster | Google Kubernetes Engine cluster used to run the Cloud Composer Environment. |