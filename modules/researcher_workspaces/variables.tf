# Egress

variable "environment" {

}

variable "billing_account" {
  description = "Google Billing Account ID"
  type        = string
}

variable "org_id" {
  description = "Organization ID"
  type        = string
}

variable "folder_id" {
  description = "Folder ID to host project"
  type        = string
}

variable "researcher_workspace_name" {
  description = "Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist."
  type        = string
  default     = "workspace-1"
}

variable "region" {
  description = "The default region to place resources."
  type        = string
  default     = "us-central1"
}

variable "data_ops_project_id" {
  description = "Project ID for data ops project"
  type        = string
}

variable "data_ops_project_number" {
  description = "Project number for data ops project"
  type        = string
}

variable "vpc_connector" {
  description = "The VPC Connector ID"
  type        = string
}

variable "pubsub_appint_results" {
  description = "The name of the Pub/Sub for Application Insights results"
  type        = string
  default     = "application-integration-trigger-results"
}

variable "data_ops_bucket" {}


variable "cloud_composer_email" {
  type = string
}

variable "composer_ariflow_uri" {
  type = string
}

variable "composer_dag_bucket" {
  type = string
}

variable "prefix" {
  type    = string
  default = "test"
}

variable "wrkspc_folders" {
  description = "Map of the researcher name to folder id"
  default     = {}
  # Example:
  # default = {
  #   "workspace-1" = "folders/<FOLDER_ID>"
  # }  
}

variable "enforce" {
  description = "Whether this policy is enforce."
  type        = bool
  default     = true
}

variable "set_disable_sa_create" {
  description = "Enable the Disable Service Account Creation policy"
  type        = bool
  default     = true
}

variable "project_admins" {
  description = "Name of the Google Group for admin level access."
  type        = list(string)
  default     = []
}

variable "external_users_vpc" {
  description = "List of individual external user ids to be added to the VPC Service Control Perimeter. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC."
  type        = list(string)
  default     = []
}

variable "lbl_department" {
  description = "Department. Used as part of the project name."
  type        = string
  default     = "pii"
}

# Workspace


variable "cloudbuild_service_account" {
  description = "Cloud Build Service Account"
  type        = string
}

variable "research_to_bucket" {

}

variable "csv_names_list" {

}

variable "imaging_project_id" {
  type = string
}

variable "apt_repo_name" {
  description = "APT Repository Name"
  type        = string
  default     = "apt-repo"
}

variable "data_ingress_project_id" {
  type = string
}

variable "data_ingress_project_number" {
  type = string
}

variable "data_ingress_bucket_names" {}

variable "imaging_bucket_name" {}

variable "data_lake_project_id" {
  type = string
}

variable "data_lake_project_number" {
  type = string
}

variable "data_lake_research_to_bucket" {

}

variable "data_lake_bucket_list_custom_role" {
  type = string
}

/******************************
 VPC Access
*******************************/

variable "access_policy_id" {
  description = "Access Policy ID"
  type        = string
}

variable "serviceaccount_access_level_name" {
  description = "Name of the Access Context for the Service Accounts"
  type        = string
}

variable "admin_access_level_name" {
  type    = string
  default = ""
}

variable "stewards_access_level_name" {
  type    = string
  default = ""
}

# END [VPC ACCESS]

variable "notebook_sa_email" {
  default = ""
}

variable "num_instances" {
  description = "Number of instances to create."
  type        = number
  default     = 0
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  type        = string
  default     = "deep-learning-vm"
}

variable "instance_tags" {
  description = "A list of network tags to attach to the instance."
  type        = list(string)
  default     = ["deep-learning-vm", "jupyter-notebook"]
}

variable "set_vm_os_login" {
  description = "Enable the requirement for OS login for VMs"
  type        = bool
  default     = true
}

variable "force_destroy" {
  default = true
}

variable "researchers" {
  description = "The list of users who get their own managed notebook. Do not pre-append with `user`."
  type        = list(string)
  default     = []
}

variable "data_stewards" {
  description = "List of or users of data stewards for this research initiative. Grants access to initiative bucket in `data-ingress`, `data-ops`. Prefix with `user:foo@bar.com`. DO NOT INCLUDE GROUPS, breaks the VPC Perimeter."
  type        = list(string)
  default     = []
}

variable "golden_image_version" {
  description = "Retrieves the specific custom image version from the image project."
  type        = string
  default     = ""
}

variable "deploy_notebook" {
  description = "deploys vertex ai notebook in the workspace"
  type        = bool
  default     = false
}

/**************************************************
  VPC Service Controls
**************************************************/

variable "access_context_manager_policy_id" {
  description = "Name of the parent policy"
  type        = string
}

variable "common_name" {
  description = "A common name to be used in the creation of the resources of the module."
  type        = string
}

variable "common_suffix" {
  description = "A common suffix to be used in the module."
  type        = string
  default     = ""
}

// ACCESS LEVELS

variable "additional_access_levels" {
  description = "Additional access levels to add to the VPC perimeter"
  type        = list(string)
  default     = []
}

variable "combining_function" {
  description = "How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied."
  type        = string
  default     = "AND"
}

variable "access_level_description" {
  description = "Description of the access level"
  type        = string
  default     = "Policy with all available options to configure. Managed by Terraform."
}

variable "access_level_ip_subnetworks" {
  description = "Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
  type        = list(string)
  default     = []
}

variable "members" {
  description = "Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
  default     = []
}

variable "access_level_regions" {
  description = "Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
  type        = list(string)
  default     = []
}

// BRIDGE

variable "bridge1_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
}

variable "bridge2_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
}

// PERIMETER

variable "perimeter_description" {
  description = "Description of the regular perimeter"
  type        = string
  default     = "Perimeter for secure workspace projects. Managed by Terraform."
}

variable "restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "access_levels" {
  description = "A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty."
  type        = list(string)
  default     = []
}

variable "restricted_services_dry_run" {
  description = "(Dry-run) GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions.  If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "resources_dry_run" {
  description = "(Dry-run) A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "access_levels_dry_run" {
  description = "(Dry-run) A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty. If set, a dry-run policy will be set."
  type        = list(string)
  default     = []
}

variable "shared_resources" {
  description = "A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources"
  type        = object({ all = list(string) })
  default     = { all = [] }
}


## Have to solve it like this don't want use optional flag because is still experimental
variable "egress_policies" {
  description = "A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress_from and egress_to.\n\nExample: `[{ from={ identities=[], identity_type=\"ID_TYPE\" }, to={ resources=[], operations={ \"SRV_NAME\"={ OP_TYPE=[] }}}}]`\n\nValid Values:\n`ID_TYPE` = `null` or `IDENTITY_TYPE_UNSPECIFIED` (only allow indentities from list); `ANY_IDENTITY`; `ANY_USER_ACCOUNT`; `ANY_SERVICE_ACCOUNT`\n`SRV_NAME` = \"`*`\" (allow all services) or [Specific Services](https://cloud.google.com/vpc-service-controls/docs/supported-products#supported_products)\n`OP_TYPE` = [methods](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions) or [permissions](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions)"
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}

## Have to solve it like this don't want use optional flag because is still experimental
variable "ingress_policies" {
  description = "A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value that describes ingress_from and ingress_to.\n\nExample: `[{ from={ sources={ resources=[], access_levels=[] }, identities=[], identity_type=\"ID_TYPE\" }, to={ resources=[], operations={ \"SRV_NAME\"={ OP_TYPE=[] }}}}]`\n\nValid Values:\n`ID_TYPE` = `null` or `IDENTITY_TYPE_UNSPECIFIED` (only allow indentities from list); `ANY_IDENTITY`; `ANY_USER_ACCOUNT`; `ANY_SERVICE_ACCOUNT`\n`SRV_NAME` = \"`*`\" (allow all services) or [Specific Services](https://cloud.google.com/vpc-service-controls/docs/supported-products#supported_products)\n`OP_TYPE` = [methods](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions) or [permissions](https://cloud.google.com/vpc-service-controls/docs/supported-method-restrictions)"
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}


## Have to solve it like this don't want use optional flag because is still experimental
variable "egress_policies_dry_run" {
  description = "A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress_from and egress_to. Use same formatting as `egress_policies`."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}

## Have to solve it like this don't want use optional flag because is still experimental
variable "ingress_policies_dry_run" {
  description = "A list of all [ingress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#ingress-rules-reference), each list object has a `from` and `to` value that describes ingress_from and ingress_to. Use same formatting as `ingress_policies`."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}

variable "vpc_accessible_services" {
  description = "A list of [VPC Accessible Services](https://cloud.google.com/vpc-service-controls/docs/vpc-accessible-services) that will be restricted within the VPC Network. Use [\"*\"] to allow any service (disable VPC Accessible Services); Use [\"RESTRICTED-SERVICES\"] to match the restricted services list; Use [] to not allow any service."
  type        = list(string)
  default     = ["*"]
}

variable "vpc_accessible_services_dry_run" {
  description = "(Dry-run) A list of [VPC Accessible Services](https://cloud.google.com/vpc-service-controls/docs/vpc-accessible-services) that will be restricted within the VPC Network. Use [\"*\"] to allow any service (disable VPC Accessible Services); Use [\"RESTRICTED-SERVICES\"] to match the restricted services list; Use [] to not allow any service."
  type        = list(string)
  default     = ["*"]
}