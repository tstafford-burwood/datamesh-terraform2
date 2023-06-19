variable "parent_access_policy_id" {
  description = "The AccessPolicy this AccessLevel lives in. One per org and must exist prior to running terraform."
  type        = number
}

variable "ip_subnetworks_admins" {
  description = "Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
  type        = list(string)
  default     = []
}

variable "ip_subnetworks_stewards" {
  description = "Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
  type        = list(string)
  default     = []
}

variable "perimeter_additional_members" {
  description = "The list additional members to be added on perimeter access. Prefix user: (user:email@email.com) or serviceAccount: (serviceAccount:my-service-account@email.com) is required."
  type        = list(string)
  default     = []
}

variable "additional_restricted_services" {
  description = "The list of additional Google services to be protected by the VPC-SC service perimeters."
  type        = list(string)
  default     = []
}

variable "data_ingestion_dataflow_deployer_identities" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email} that will deploy Dataflow jobs in the Data Ingestion project. These identities will be added to the VPC-SC secure data exchange egress rules."
  type        = list(string)
  default     = []
}

variable "egress_policies" {
  description = "A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress_from and egress_to. See also [secure data exchange](https://cloud.google.com/vpc-service-controls/docs/secure-data-exchange#allow_access_to_a_google_cloud_resource_outside_the_perimeter)."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}