resource "google_cloudbuild_trigger" "bootstrap" {
  project = var.project_id
  name    = "bootstrap-trigger"

  source_to_build {
    uri       = var.git_repo_url
    ref       = var.git_ref
    repo_type = var.git_repo_type
  }


  git_file_source {
    path      = var.git_path
    repo_type = var.git_repo_type
    revision  = var.git_ref
    uri       = var.git_repo_url
  }

  substitutions = {
    _BUCKET = google_storage_bucket.tfstate.name
    _PREFIX = "foundation"
    _TAG    = var.terraform_version
  }
}

variable "git_repo_url" {
  description = "URL of the repository where the module code will be stored.  Used by Cloud Build to retrieve the source code and build modules.  If you want to use the open source repository, this can be set to https://github.com/GoogleCloudPlatform/rad-lab."
  type        = string
}

variable "git_ref" {
  description = "What ref should be built by the Cloud Build trigger."
  type        = string
  default     = "refs/heads/main"
}

variable "git_repo_type" {
  description = "What the type of repository is.  Can only contain GITHUB, CLOUD_SOURCE_REPOSITORIES or UNKNOWN."
  type        = string
  default     = "GITHUB"

  validation {
    condition     = var.git_repo_type == "GITHUB" || var.git_repo_type == "CLOUD_SOURCE_REPOSITORIES" || var.git_repo_type == "UNKNOWN"
    error_message = "Git repo type can only be set to GITHUB, CLOUD_SOURCE_REPOSITORIES or UNKNOWN."
  }
}

variable "git_path" {
  description = "The path of the file, with the repo root as the root of the path."
  type        = string
}