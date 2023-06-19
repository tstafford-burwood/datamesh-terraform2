# VPC Peering for Cloud services

Some GCP cloud services require a special peering between your VPC network and a VPC managed by Google. The module supports creating such a peering.

## Example
```hcl
module "psc" {
    source = "./"
    
    project_id    = "my-project"
    vpc_network   = "default"
    address       = "172.17.0.0"
    prefix_length = "24"
}
```

<!-- BEGIN TFDOC -->

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [project_id](variables.tf#L1) | Project ID for Private Service Connect. | <code>string</code> | ✓ |  |
| [vpc_network](variables.tf#L6) | Name of the VPC network to peer. | <code>string</code> | ✓ |  |
| [address](variables.tf#L11) | First IP address of the IP range to allocate to instances and other Private Service Access services. If not set, GCP will pick a valid one for you. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [description](variables.tf#L17) | An optional description of the Global Address resource. | <code>string</code> |  | <code>&#34;Terraform managed&#34;</code> |
| [ip_version](variables.tf#L29) | IP Version for the allocation. Can be IPV4 or IPV6. | <code>string</code> |  | <code>&#34;IPV4&#34;</code> |
| [labels](variables.tf#L35) | The key/value labels for the IP range allocated to the peered network. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |
| [prefix_length](variables.tf#L23) | Prefix length of the IP range reserved for Cloud SQL instances and other Private Service Access services. Defaults to /16. | <code>number</code> |  | <code>16</code> |
| [purpose](variables.tf#L41) | The purpose of the resource. Possible values include:`VPC_PEERING` or `PRIVATE_SERVICE_CONNECT` | <code>string</code> |  | <code>&#34;VPC_PEERING&#34;</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [address](outputs.tf#L1) | First IP of the reserved range. |  |
| [google_compute_global_address_name](outputs.tf#L6) | URL of the reserved range. |  |
| [peering_completed](outputs.tf#L11) | Use for enforce ordering between resource creation |  |

<!-- END TFDOC -->
