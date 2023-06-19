#------------------------------------
# PUB/SUB TOPIC IAM MEMBER VARIABLES
#------------------------------------

// REQUIRED VARIABLES

variable "project_id" {
  description = "The Project ID that contains the Pub/Sub topic that will have a member and an IAM role applied to."
  type        = string
  default     = ""
}

variable "topic_name" {
  description = "The Pub/Sub Topic name. Used to find the parent resource to bind the IAM policy to."
  type        = string
  default     = ""
}

variable "iam_member" {
  description = "The member that will have the defined IAM role applied to. Refer [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam) for syntax of members."
  type        = string
  default     = ""
}

variable "role" {
  description = "The IAM role to set for the member. Only one role can be set. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`"
  type        = string
  default     = ""
}