# VPC Service Controls and Bridges

This repository provides an opinionated way to deploy VPC Service Perimeters and Access Context Managers. 

## Reference Architecture
![](../../../docs/foundation-vpc-sc.png)

This module handles the creation of VPC Service Controls and Access Context Management configuration and deployments for all the foundation projects: `data-lake`, `data-ops`, `ingress`, and `image-factory`.

The resources that this module will create are:

* Three different access context managers:
    1. `{env}_cloudbuild`: A <b>required</b> resource to build a list of service accounts that need access to the different projects to move data around (cloud composer sa), read data from data lake (notebook-sa) or to read configurations (prisma-sa).
    1. `{env}_admins`: An <i>optional</i> resource to add IT admins to the list of foundation project.
    1. `{env}_stewards`: A <b>required</b> resource to add users to upload data to the GCS buckets in the `ingress` project. Add users to the constants [vpc_sc_users ](../constants/constants.tf#L29) variable.
* Two service perimeters
    1. That includes `data-lake`, `data-ops`, and `ingress` projects.
    1. That includes the `image` project.


### Known limitations

The [Access Context Manager API](https://cloud.google.com/access-context-manager/docs/) guarantees that resources will be created, but there may be a delay between a successful response and the change taking effect. For example, ["after you create a service perimeter, it may take up to 30 minutes for the changes to propagate and take effect"](https://cloud.google.com/vpc-service-controls/docs/create-service-perimeters).
Because of these limitations in the API, you may first get an error when running `terraform apply` for the first time.

### Notes

- To remove an access level, first remove the binding between perimeter and the access level without removing the access level itself. Once you have run `terraform apply`, you'll then be able to remove the access level and run `terraform apply` again.



<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules | resources |
|---|---|---|---|
| [backend.tf](./backend.tf) | None |  |  |
| [data.tf](./data.tf) | None | <code>constants</code> |  |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>vpc-sc</code> | <code>random_id</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |  |
| [variables.tf](./variables.tf) | Module variables. |  |  |
| [versions.tf](./versions.tf) | Version pins. |  |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [parent_access_policy_id](variables.tf#L1) | The AccessPolicy this AccessLevel lives in. One per org and must exist prior to running terraform. | <code>number</code> | ✓ |  |  |
| [additional_restricted_services](variables.tf#L24) | The list of additional Google services to be protected by the VPC-SC service perimeters. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [data_ingestion_dataflow_deployer_identities](variables.tf#L30) | List of members in the standard GCP form: user:{email}, serviceAccount:{email} that will deploy Dataflow jobs in the Data Ingestion project. These identities will be added to the VPC-SC secure data exchange egress rules. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [egress_policies](variables.tf#L36) | A list of all [egress policies](https://cloud.google.com/vpc-service-controls/docs/ingress-egress-rules#egress-rules-reference), each list object has a `from` and `to` value that describes egress_from and egress_to. See also [secure data exchange](https://cloud.google.com/vpc-service-controls/docs/secure-data-exchange#allow_access_to_a_google_cloud_resource_outside_the_perimeter). | <code title="list&#40;object&#40;&#123;&#10;  from &#61; any&#10;  to   &#61; any&#10;&#125;&#41;&#41;">list&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [ip_subnetworks_admins](variables.tf#L6) | Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [ip_subnetworks_stewards](variables.tf#L12) | Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |
| [perimeter_additional_members](variables.tf#L18) | The list additional members to be added on perimeter access. Prefix user: (user:email@email.com) or serviceAccount: (serviceAccount:my-service-account@email.com) is required. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [image_prj_serviceaccount_access_level_name](outputs.tf#L15) | Name of the Access Level to access the imaging project perimeter |  |  |
| [parent_access_policy_id](outputs.tf#L1) | Access Policy ID |  | <code>egress,</code> · <code>workspaces</code> |
| [serviceaccount_access_level_name](outputs.tf#L7) | Description of the Service account AccessLevel and its use. Does not affect behavior. |  | <code>egress,</code> · <code>workspaces</code> |

<!-- END TFDOC -->
