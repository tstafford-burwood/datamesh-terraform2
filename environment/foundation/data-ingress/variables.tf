variable "project_iam_admin_roles" {
  description = "List of roles to assign to admins"
  type        = list(string)
  default = [
    "roles/viewer",              # Grants permissions to list buckets in the project
    "roles/storage.objectAdmin", # Grants full control of objects, including listing, creating, viewing, and deleting objects
    # "roles/owner"              # # TEMP - BREAK GLASS
  ]
}

variable "subnet_cidr" {
  description = "Subnet CIDR range"
  type        = string
  default     = "172.16.0.0/24"
}

variable "gcs_bucket" {
  description = "List of bucket names to create."
  type        = list(string)
  default     = ["ingress-example-here"]
}

variable "enforce" {
  description = "Whether this policy is enforced."
  type        = bool
  default     = true
}

#--------------------------------------
# PROJECT LABELS, if any
#--------------------------------------