#------------------------------------------
# SINGLE VM INSTANCE - PRIVATE IP VARIABLES
#------------------------------------------

variable "allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  type        = bool
  default     = true
}

variable "vm_description" {
  description = "A description of the VM instance."
  type        = string
  default     = "VM created with Terraform"
}

variable "desired_status" {
  description = "Desired status of the instance. Either `RUNNING` or `TERMINATED`."
  type        = string
  default     = "RUNNING"
}

variable "deletion_protection" {
  description = "Enable deletion protection on this instance. Defaults to false. You must disable deletion protection before the resource can be removed (e.g., via terraform destroy). Otherwise the instance cannot be deleted and the Terraform run will not complete successfully."
  type        = bool
  default     = false
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "metadata" {
  description = "Metadata key/value pairs to make available from within the instance. SSH keys attached in the Cloud Console will be removed. Add them to your configuration in order to keep them attached to your instance."
  type        = map(string)
  default     = {}
}

variable "metadata_startup_script" {
  description = "An alternative to using the startup-script metadata key, except this one forces the instance to be recreated (thus re-running the script) if it is changed. This replaces the startup-script metadata key on the created instance and thus the two mechanisms are not allowed to be used simultaneously. Users are free to use either mechanism - the only distinction is that this separate attribute will cause a recreate on modification. On import, metadata_startup_script will be set, but metadata.startup-script will not - if you choose to use the other mechanism, you will see a diff immediately after import, which will cause a destroy/recreate operation. You may want to modify your state file manually using terraform state commands, depending on your use case."
  type        = string
  default     = ""
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "machine_type" {
  description = "The machine type to create. For example `n2-standard-2`."
  type        = string
  default     = ""
}

variable "vm_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "A list of network tags to attach to the instance."
  type        = list(string)
  default     = []
}

variable "zone" {
  description = "The zone that the machine should be created in."
  type        = string
}

// BOOT DISK BLOCK VARIABLES

variable "auto_delete_disk" {
  description = "Whether the disk will be auto-deleted when the instance is deleted. Defaults to true."
  type        = bool
  default     = true
}

variable "device_name" {
  description = "Name with which attached disk will be accessible. On the instance, this device will be `/dev/disk/by-id/google-{{device_name}}`."
  type        = string
  default     = ""
}

variable "disk_mode" {
  description = "The mode in which to attach this disk, either READ_WRITE or READ_ONLY. If not specified, the default is to attach the disk in READ_WRITE mode."
  type        = string
  default     = "READ_WRITE"
}

variable "kms_key_self_link" {
  description = "The self_link of the encryption key that is stored in Google Cloud KMS to encrypt this disk. Only one of kms_key_self_link and disk_encryption_key_raw may be set."
  type        = string
  default     = ""
}

variable "source_disk" {
  description = "The name or self_link of the existing disk (such as those managed by google_compute_disk) or disk image. To create an instance from a snapshot, first create a google_compute_disk from a snapshot and reference it here."
  type        = string
  default     = ""
}

variable "initialize_params" {
  description = "Parameters for a new disk that will be created alongside the new instance. Either initialize_params or source_disk must be set. Structure is documented below."
  type = list(object({
    vm_disk_size  = number
    vm_disk_type  = string
    vm_disk_image = string
  }))
  default = []
}

variable "vm_disk_size" {
  description = "Placeholder variable to define initialize_params input. The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  type        = number
  default     = null
}

variable "vm_disk_type" {
  description = "Placeholder variable to define initialize_params input. The GCE disk type. May be set to pd-standard, pd-balanced or pd-ssd."
  type        = string
  default     = null
}

variable "vm_disk_image" {
  description = "Placeholder variable to define initialize_params input. The image from which to initialize this disk. More detail can be found with the command `gcloud compute images list`. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}. If referred by family, the images names must include the family name. If they don't, use the google_compute_image data source. For instance, the image centos-6-v20180104 includes its family name centos-6. These images can be referred by family name here."
  type        = string
  default     = null
}

// NETWORK INTERFACE

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. If network isn't provided it will be inferred from the subnetwork. Either network or subnetwork must be provided."
  type        = string
  default     = ""
}

variable "network_ip" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  type        = string
  default     = ""
}

// SERVICE ACCOUNT

variable "service_account_email" {
  description = "The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = string
  default     = ""
}

variable "service_account_scopes" {
  description = "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. See a complete list of scopes here. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = list(string)
  default     = []
}

// SHIELDED INSTANCE CONFIGURATION

variable "enable_secure_boot" {
  description = "Verify the digital signature of all boot components, and halt the boot process if signature verification fails. Defaults to false. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = false
}

variable "enable_vtpm" {
  description = "Use a virtualized trusted platform module, which is a specialized computer chip you can use to encrypt objects like keys and certificates. Defaults to true. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Compare the most recent boot measurements to the integrity policy baseline and return a pair of pass/fail results depending on whether they match or not. Defaults to true. Note: allow_stopping_for_update must be set to true or your instance must have a desired_status of TERMINATED in order to update this field."
  type        = bool
  default     = true
}