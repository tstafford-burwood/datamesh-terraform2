# Terraform Module for Provisioning Cloud DNS Zones

The purpose of this directory is to provision Cloud DNS Zones (public or private) and manage records (A, CNAME, etc.).

## Usage

Below is an example of how to use this module.

```terraform
module "cloud-dns" {
  source  = "./modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = "googleapis.com"
  cloud_dns_name       = "my-dns-name"
  cloud_dns_project_id = "project1234"

  // OPTIONAL
  default_key_specs_key              = var.default_key_specs_key
  default_key_specs_zone             = var.default_key_specs_zone
  cloud_dns_description              = "Readable description."
  dnssec_config                      = var.dnssec_config
  cloud_dns_labels                   = {"label":"purpose"}
  private_visibility_config_networks = ["https://www.googleapis.com/compute/v1/projects/my-project/global/networks/my-vpc"]
  cloud_dns_recordsets               = [
    {
      name    = "Recordset Name"
      type    = "NS"
      ttl     = 300
      records = [
        "127.0.0.1",
      ]
    }
  ]
  target_name_server_addresses       = var.target_name_server_addresses
  cloud_dns_target_network           = "my_vpc_network"
  cloud_dns_zone_type                = "private"
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| cloud-dns | terraform-google-modules/cloud-dns/google | ~> 3.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud\_dns\_description | zone description (shown in console) | `string` | `"Managed by Terraform"` | no |
| cloud\_dns\_domain | Zone domain, must end with a period. | `string` | n/a | yes |
| cloud\_dns\_labels | A set of key/value label pairs to assign to this ManagedZone | `map(any)` | `{}` | no |
| cloud\_dns\_name | Zone name, must be unique within the project. | `string` | n/a | yes |
| cloud\_dns\_project\_id | Project id for the zone. | `string` | n/a | yes |
| cloud\_dns\_recordsets | List of DNS record objects to manage, in the standard Terraform DNS structure. | <pre>list(object({<br>    name    = string<br>    type    = string<br>    ttl     = number<br>    records = list(string)<br>  }))</pre> | `[]` | no |
| cloud\_dns\_target\_network | Peering network. | `string` | `""` | no |
| cloud\_dns\_zone\_type | Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering'. | `string` | `"private"` | no |     
| default\_key\_specs\_key | Object containing default key signing specifications : algorithm, key\_length, key\_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | `any` | `{}` | no |
| default\_key\_specs\_zone | Object containing default zone signing specifications : algorithm, key\_length, key\_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | `any` | `{}` | no |
| dnssec\_config | Object containing : kind, non\_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html#dnssec_config for futhers details | `any` | `{}` | no |
| private\_visibility\_config\_networks | List of VPC self links that can see this zone. | `list(string)` | `[]` | no |
| target\_name\_server\_addresses | List of target name servers for forwarding zone. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain | The DNS zone domain. |
| name | The DNS zone name. |
| name\_servers | The DNS zone name servers. |
| type | The DNS zone type. |