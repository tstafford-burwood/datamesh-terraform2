resource "google_cloudbuild_trigger" "packer_container_image" {
  # Trigger to build a packer container
  project = local.automation_project_id
  name    = format("%s-packer-container-image", local.environment[terraform.workspace])

  description    = "Pipeline for Packer container image created with Terraform"
  filename       = "cloudbuild/foundation/image-container.yaml"
  included_files = ["environment/foundation/image/packer-container/Dockerfile"]

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = false
      branch       = var.branch_name
    }
  }

  substitutions = {
    _BUCKET                   = local.terraform_state_bucket
    _TAG                      = local.terraform_container_version
    _REGION                   = local.default_region
    _PREFIX                   = "foundation"
    _PACKER_VERSION           = "1.8.4"
    _PACKER_VERSION_SHA256SUM = "ba25b84cc4d3541e9a1dcc0b8e1c7c693f1b39a5d129149194eb6b6050ae56c3"
    _PATH_TO_DOCKERFILE       = "environment/foundation/image/packer-container"
    _REPO_NAME                = "packer"
    _IMAGE_NAME               = "packer"
  }
}

resource "google_cloudbuild_trigger" "researcher_vm_image" {
  # Trigger to build a researcher VM from the Packer container 
  project = local.automation_project_id
  name    = format("%s-researcher-vm-image", local.environment[terraform.workspace])

  filename       = "cloudbuild/foundation/packer-researcher-vm.yaml"
  included_files = ["cloudbuild/foundation/packer-researcher-vm.yaml"]

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = false
      branch       = var.branch_name
    }
  }

  substitutions = {
    _BUCKET = local.terraform_state_bucket
    _PREFIX = "foundation"
    _TAG    = local.terraform_container_version
    _REGION = local.default_region
  }
}

# resource "google_cloudbuild_trigger" "copy_dags" {
#   # Build the trigger to copy dag files to cloud composer
#   project     = local.automation_project_id
#   name        = format("%s-copy-dags", local.environment[terraform.workspace])
#   description = "Terraform Managed - Copies DAG files to the Cloud Composer DAG GCS bucket"

#   filename       = "cloudbuild/foundation/dags-build.yaml"
#   included_files = ["environment/foundation/data-ops/cloud-composer/composer-dag-files/**"]

#   github {
#     owner = var.github_owner
#     name  = var.github_repo_name
#     push {
#       invert_regex = false
#       branch       = var.branch_name
#     }
#   }

#   substitutions = {
#     _BUCKET      = local.terraform_state_bucket
#     _PREFIX      = local.terraform_foundation_state_prefix
#     _TFVARS_FILE = local.included_files
#     _TAG         = local.terraform_container_version
#   }
# }