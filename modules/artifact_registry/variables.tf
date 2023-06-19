#---------------------------------------
# ARTIFACT REGISTRY REPOSITORY VARIABLES
#---------------------------------------

variable "artifact_repository_project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = ""
}

variable "artifact_repository_name" {
  description = "The name of the repository that will be provisioned."
  type        = string
  default     = ""
}

variable "artifact_repository_format" {
  description = "The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha)."
  type        = string
  default     = ""
}

variable "artifact_repository_location" {
  description = "The name of the location this repository is located in."
  type        = string
  default     = ""
}

variable "artifact_repository_description" {
  description = "The user-provided description of the repository."
  type        = string
  default     = "Artifact Registry Repository created with Terraform."
}

variable "artifact_repository_labels" {
  description = "Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes."
  type        = map(string)
  default     = {}
}
