# Terraform Module for Reserving a Regional External Static IP

This module is used to reserve a regional external static IP address. The IP address will be assigned by GCP and is not declared directly in this module due to the `address_type = EXTERNAL`.

**NOTE** For `address_type` keep that as `"EXTERNAL"`. This module will not work with `INTERNAL`.

## Usage

Below is an example of how to use this module.

```terraform
module "regional_static_ip" {
  source = "./modules/regional_static_ip"

  // REQUIRED
  name = var.name

  // OPTIONAL
  project      = var.project_id
  address_type = "EXTERNAL"
  description  = var.description
  network_tier = "PREMIUM"
  region       = "us-central1"
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_compute_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| regional\_external\_static\_ip\_address\_type | The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL. | `string` | `"EXTERNAL"` | no |
| regional\_external\_static\_ip\_description | The description to attach to the IP address. | `string` | `"Created with Terraform"` | no |
| regional\_external\_static\_ip\_name | The name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash. | `string` | `""` | no |
| regional\_external\_static\_ip\_network\_tier | The networking tier used for configuring this address. If this field is not specified, it is assumed to be PREMIUM. Possible values are PREMIUM and STANDARD. | `string` | `"PREMIUM"` | no |
| regional\_external\_static\_ip\_project\_id | The project ID to provision this resource into. | `string` | `""` | no |
| regional\_external\_static\_ip\_region | The Region in which the created address should reside. If it is not provided, the provider region is used. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| self\_link | Self link to the URI of the created resource. |