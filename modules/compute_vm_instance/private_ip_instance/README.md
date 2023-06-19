# Terraform Module for a Single VM Instance - Private IP

This module is used to provision a single VM instance with a private IP and no defined public IP.

**NOTE** Certain tfvar field updates will cause the instance to be re-created such as in the `initialize_params` variable. When updating tfvars for an instance after it has been provisioned and has a workload running it is best practice to run a `terraform plan` to see if the instance will either be updated in place or destroyed and re-created.

## Usage

Below is an example of how to use use this module.

```terraform
module "single_vm_instance" {
  source = "./modules/compute_vm_instance/private_ip_instance"

  allow_stopping_for_update = true
  vm_description            = "VM made with Terraform"
  desired_status            = RUNNING
  deletion_protection       = false
  labels                    = {"researcher":"vm"}
  metadata                  = var.metadata
  project_id                = module.researcher-workspace-project.project_id
  machine_type              = var.machine_type
  name                      = var.name
  tags                      = var.tags
  zone                      = var.zone

  // BOOT DISK

  initialize_params = var.initialize_params
  auto_delete_disk  = var.auto_delete_disk

  // NETWORK INTERFACE

  subnetwork = module.vpc.subnets_self_links[0]
  network_ip = "" // KEEP AS AN EMPTY STRING FOR AN AUTOMATICALLY ASSIGNED PRIVATE IP

  // SERVICE ACCOUNT

  service_account_email  = var.service_account_email
  service_account_scopes = var.service_account_scopes

  // SHIELDED INSTANCE CONFIG

  enable_secure_boot          = var.enable_secure_boot
  enable_vtpm                 = var.enable_vtpm
  enable_integrity_monitoring = var.enable_integrity_monitoring
}
```

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Resources

| Name |
|------|
| [google_compute_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_stopping\_for\_update | If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail. | `bool` | `true` | no |
| auto\_delete\_disk | Whether the disk will be auto-deleted when the instance is deleted. Defaults to true. | `bool` | `true` | no |
| deletion\_protection | Enable deletion protection on this instance. Defaults to false. You must disable deletion protection before the resource can be removed (e.g., via terraform destroy). Otherwise the instance cannot be deleted and the Terraform run will not complete successfully. | `bool` | `false` | no |
| desired\_status | Desired status of the instance. Either `RUNNING` or `TERMINATED`. | `string` | `"RUNNING"` | no |
| device\_name | Name with which attached disk will be accessible. On the instance, this device will be `/dev/disk/by-id/google-{{device_name}}`. | `string` | `""` | no |
| disk\_mode | The mode in which to attach this disk, either READ\_WRITE or READ\_ONLY. If not specified, the default is to attach the disk in READ\_WRITE mode. | `string` | `"READ_WRITE"` | no |
| enable\_integrity\_monitoring | Compare the most recent boot measurements to the integrity policy baseline and return a pair of pass/fail results depending on whether they match or not. Defaults to true. Note: allow\_stopping\_for\_update must be set to true or your instance must have a desired\_status of TERMINATED in order to update this field. | `bool` | `true` | no |
| enable\_secure\_boot | Verify the digital signature of all boot components, and halt the boot process if signature verification fails. Defaults to false. Note: allow\_stopping\_for\_update must be set to true or your instance must have a desired\_status of TERMINATED in order to update this field. | `bool` | `false` | no |
| enable\_vtpm | Use a virtualized trusted platform module, which is a specialized computer chip you can use to encrypt objects like keys and certificates. Defaults to true. Note: allow\_stopping\_for\_update must be set to true or your instance must have a desired\_status of TERMINATED in order to update this field. | `bool` | `true` | no |
| initialize\_params | Parameters for a new disk that will be created alongside the new instance. Either initialize\_params or source\_disk must be set. 
Structure is documented below. | <pre>list(object({<br>    vm_disk_size  = number<br>    vm_disk_type  = string<br>    vm_disk_image = string<br>  }))</pre> | `[]` | no |
| kms\_key\_self\_link | The self\_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk. Only one of kms\_key\_self\_link and disk\_encryption\_key\_raw may be set. | `string` | `""` | no |
| labels | A map of key/value label pairs to assign to the instance. | `map(string)` | `{}` | no |
| machine\_type | The machine type to create. For example `n2-standard-2`. | `string` | `""` | no |
| metadata | Metadata key/value pairs to make available from within the instance. SSH keys attached in the Cloud Console will be removed. Add them to your configuration in order to keep them attached to your instance. | `map(string)` | `{}` | no |
| metadata\_startup\_script | An alternative to using the startup-script metadata key, except this one forces the instance to be recreated (thus re-running the script) if it is changed. This replaces the startup-script metadata key on the created instance and thus the two mechanisms are not allowed to be used simultaneously. Users are free to use either mechanism - the only distinction is that this separate attribute will cause a recreate on modification. On import, metadata\_startup\_script will be set, but metadata.startup-script will not - if you choose to use the other mechanism, you will see a diff immediately after import, which will cause a destroy/recreate operation. You may want to modify your state file manually using terraform state commands, depending on your use case. | `string` | `""` | no |
| network\_ip | The private IP address to assign to the instance. If empty, the address will be automatically assigned. | `string` | `""` | no |
| project\_id | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| service\_account\_email | The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow\_stopping\_for\_update must be set to true or your instance must have a desired\_status of TERMINATED in order to update this field. | `string` | `""` | no || service\_account\_scopes | A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. See a complete list of scopes here. Note: allow\_stopping\_for\_update must be set to true or your instance must have a desired\_status of TERMINATED in order to update this field. | `list(string)` | `[]` | no |
| source\_disk | The name or self\_link of the existing disk (such as those managed by google\_compute\_disk) or disk image. To create an instance from a snapshot, first create a google\_compute\_disk from a snapshot and reference it here. | `string` | `""` | no |
| subnetwork | The name or self\_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. If network isn't provided it will be inferred from the subnetwork. Either network or subnetwork must be provided. | `string` | `""` | no |    
| tags | A list of network tags to attach to the instance. | `list(string)` | `[]` | no |
| vm\_description | A description of the VM instance. | `string` | `"VM created with Terraform"` | no |
| vm\_disk\_image | Placeholder variable to define initialize\_params input. The image from which to initialize this disk. More detail can be found with the command `gcloud compute images list`. This can be one of: the image's self\_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}. If referred by family, the images names must include the family name. If they don't, use the google\_compute\_image data source. For instance, the image centos-6-v20180104 includes its family name centos-6. These images can be referred by family name here. | `string` | `null` | no |
| vm\_disk\_size | Placeholder variable to define initialize\_params input. The size of the image in gigabytes. If not specified, it will inherit the size of its base image. | `number` | `null` | no |
| vm\_disk\_type | Placeholder variable to define initialize\_params input. The GCE disk type. May be set to pd-standard, pd-balanced or pd-ssd. | `string` | `null` | no |
| vm\_name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | `string` | n/a | yes |
| zone | The zone that the machine should be created in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_id | The server-assigned unique identifier of this instance. |
| self\_link | The URI of the instance that was created. |
| tags | The tags applied to the VM instance. |