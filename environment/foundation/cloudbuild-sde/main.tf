#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

#----------------------------------------------------------------------------
# SETUP LOCALS
#----------------------------------------------------------------------------

locals {
  environment                = module.constants.value.environment
  automation_project_id      = module.constants.value.automation_project_id
  terraform_state_bucket     = module.constants.value.terraform_state_bucket
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  folder_id                  = module.constants.value.sde_folder_id
  default_region             = module.constants.value.default_region

  terraform_foundation_state_prefix = "foundation"
  terraform_container_version       = "1.3.6"
  included_files                    = "terraform"
}

# ---------------------------------------
# COMPOSER TRIGGERS
# ---------------------------------------

# resource "google_cloudbuild_trigger" "composer_apply_triggers" {
#   project = local.automation_project_id
#   name    = format("%s-%s-apply", local.environment[terraform.workspace], "sde-composer")

#   disabled       = var.plan_trigger_disabled
#   filename       = format("%s-apply.yaml", "cloudbuild/foundation/composer")
#   included_files = formatlist("environment/foundation/data-ops/cloud-composer/env/%s.tfvars", local.included_files)

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
#     _PREFIX      = format("%s", local.terraform_foundation_state_prefix)
#     _TAG         = local.terraform_container_version
#     _TFVARS_FILE = local.included_files
#   }
# }

# resource "google_cloudbuild_trigger" "composer_plan_triggers" {
#   project = local.automation_project_id
#   name    = format("%s-%s-plan", local.environment[terraform.workspace], "sde-composer")

#   disabled       = var.plan_trigger_disabled
#   filename       = format("%s-plan.yaml", "cloudbuild/foundation/composer")
#   included_files = formatlist("environment/foundation/data-ops/cloud-composer/env/%s.tfvars", local.included_files)

#   github {
#     owner = var.github_owner
#     name  = var.github_repo_name
#     pull_request {
#       invert_regex    = false
#       branch          = var.branch_name
#       comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
#     }
#   }

#   substitutions = {
#     _BUCKET      = local.terraform_state_bucket
#     _PREFIX      = format("%s", local.terraform_foundation_state_prefix)
#     _TAG         = local.terraform_container_version
#     _TFVARS_FILE = local.included_files
#   }
# }

# -----------------------------------------------------------------------
# Entire Workflow
# -----------------------------------------------------------------------

resource "google_cloudbuild_trigger" "workflow_apply_triggers" {
  project = local.automation_project_id
  name    = format("%s-%s-apply", local.environment[terraform.workspace], "sde-workflow-foundation")

  disabled = var.plan_trigger_disabled
  filename = format("%s-apply.yaml", "cloudbuild/foundation/workflow-foundation")

  # There has to be a better way of adding these included files
  included_files = [
    "environment/foundation/folders/env/${local.included_files}.tfvars",
    "environment/foundation/data-ingress/env/${local.included_files}.tfvars",
    "environment/foundation/image/env/${local.included_files}.tfvars",
    "environment/foundation/data-ops/env/${local.included_files}.tfvars",
    "environment/foundation/data-lake/env/${local.included_files}.tfvars",
    "environment/foundation/vpc-sc/env/${local.included_files}.tfvars",
  ]

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = false
      branch       = var.branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = format("%s", local.terraform_foundation_state_prefix)
    _TAG         = local.terraform_container_version
    _TFVARS_FILE = local.included_files
  }
}

resource "google_cloudbuild_trigger" "workflow_plan_triggers" {
  project = local.automation_project_id
  name    = format("%s-%s-plan", local.environment[terraform.workspace], "sde-workflow-foundation")

  disabled = false
  filename = format("%s-plan.yaml", "cloudbuild/foundation/workflow-foundation")

  # There has to be a better way of adding these included files
  included_files = [
    "environment/foundation/folders/env/${local.included_files}.tfvars",
    "environment/foundation/data-ingress/env/${local.included_files}.tfvars",
    "environment/foundation/image/env/${local.included_files}.tfvars",
    "environment/foundation/data-ops/env/${local.included_files}.tfvars",
    "environment/foundation/data-lake/env/${local.included_files}.tfvars",
    "environment/foundation/vpc-sc/env/${local.included_files}.tfvars",
  ]

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    pull_request {
      invert_regex    = false
      branch          = var.branch_name
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = format("%s", local.terraform_foundation_state_prefix)
    _TAG         = local.terraform_container_version
    _TFVARS_FILE = local.included_files
  }
}

#------------------------------------------------------------------------
# FOLDER IAM MEMBER MODULE
#------------------------------------------------------------------------

module "folder_iam_member" {
  source = "../../../modules/iam/folder_iam"

  folder_id     = local.folder_id
  iam_role_list = var.iam_role_list
  folder_member = "serviceAccount:${local.cloudbuild_service_account}"
}