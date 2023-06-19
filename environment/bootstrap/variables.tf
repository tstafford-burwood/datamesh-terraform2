variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "billing_display_name" {
  description = "The billing account display name"
  type        = string
}

variable "project_id" {
  description = "The Google Project ID to host the bucket."
  type        = string
  default     = "github-actions-demos"
}

variable "location" {
  description = "The location of place the bucket"
  type        = string
  default     = "us-central1"
}

# --- IAM

variable "cloudbuild_iam_roles" {
  description = "The IAM role(s) to assign to the `Admins` at the defined project."
  type        = list(string)
  default = [
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/logging.configWriter"
  ]
}

variable "cloudbuild_service_account" {
  description = "Cloud Build Service Account"
  type        = string
}

# --- Folders

variable "folder_name" {
  description = "Folder name"
  type        = string
  default     = "SDE"
}

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

# --- Bucket

variable "storage_class" {
  description = "The Storage class of the new bucket. Supported values: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE`"
  type        = string
  default     = "STANDARD"
}

# --- API Services

variable "services" {
  description = "List of API services to enable in the Cloud Build project"
  type        = list(string)
  default     = ["dlp.googleapis.com", "accesscontextmanager.googleapis.com", "cloudbuild.googleapis.com", "iam.googleapis.com", "cloudbilling.googleapis.com", "cloudresourcemanager.googleapis.com", "servicenetworking.googleapis.com", "dataflow.googleapis.com"]
}

# --- Trigger

variable "terraform_version" {
  description = "The Terraform CLI version."
  type        = string
  default     = "1.3.6"
}