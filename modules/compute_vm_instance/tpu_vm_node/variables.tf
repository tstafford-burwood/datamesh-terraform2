#------------------------------
# COMPUTE TPU VM NODE VARIABLES
#------------------------------

// REQUIRED VARIABLES

variable "tpu_node_name" {
  description = "Name of the TPU node."
  type        = string
  default     = ""
}

variable "tpu_node_accelerator_type" {
  description = "Accelerator type to use with the TPU Node. Available options can be found with `gcloud alpha compute tpus accelerator-types list --zone=<ZONE>`."
  type        = string
  default     = ""
}

variable "tpu_node_tensorflow_version" {
  description = "The version of Tensorflow to use on the TPU node. Additional options can be seen with `gcloud alpha compute tpus versions list --zone=<ZONE>`."
  type        = string
  default     = ""
}

variable "tpu_node_project_id" {
  description = "Project ID to provision the TPU node into."
  type        = string
  default     = ""
}

variable "tpu_node_preemptible" {
  description = "Defines whether the TPU instance is preemptible."
  type        = bool
  default     = false
}

// OPTIONAL VARIABLES

variable "tpu_node_description" {
  description = "Description for the TPU node."
  type        = string
  default     = "TPU Node created with Terraform."
}

variable "tpu_node_network" {
  description = "The name of a network to peer the TPU node to. It must be a preexisting Compute Engine network inside of the project on which this API has been activated. If none is provided, `default` will be used."
  type        = string
  default     = ""
}

variable "tpu_node_use_service_networking" {
  description = "Whether the VPC peering for the node is set up through Service Networking API. The VPC Peering should be set up before provisioning the node. If this field is set, cidr_block field should not be specified. If the network that you want to peer the TPU Node to is a Shared VPC network, the node must be created with this this field enabled."
  type        = bool
  default     = false
}

variable "tpu_node_labels" {
  description = "Resource labels to represent user provided metadata."
  type        = map(string)
  default     = {}
}

variable "tpu_node_zone" {
  description = "The GCP location for the TPU. If it is not provided, the provider zone is used."
  type        = string
  default     = ""
}