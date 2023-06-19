data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

locals {
  # researcher_triggers = {
  #   "06A-researcher" = "Project-X",
  #   "06B-researcher" = "Project-Z",
  # }

  # Read list of folders and create a trigger per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : k]
}

# ---------------------------------------
# RESEARCHER TRIGGERS
# ---------------------------------------

resource "google_cloudbuild_trigger" "researcher_apply_triggers" {
  for_each = toset(local.research_wrkspc)

  project = local.automation_project_id
  name    = format("%s-sde-research-%s-apply", local.environment[terraform.workspace], lower(each.value))

  disabled = var.plan_trigger_disabled
  filename = format("%s-apply.yaml", "cloudbuild/deployments/researcher-workspace-project")
  included_files = [
    format("environment/deployments/researcher-projects/env/%s.auto.tfvars", each.value),
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
    _BUCKET            = local.terraform_state_bucket
    _PREFIX            = "deployments"
    _PREFIX_FOUNDATION = format("%s", local.terraform_foundation_state_prefix)
    _TAG               = local.terraform_container_version
    _TFVARS_FILE       = local.included_files
    _WORKSPACE         = each.value
  }
}

resource "google_cloudbuild_trigger" "researcher_plan_triggers" {
  for_each = toset(local.research_wrkspc)

  project = local.automation_project_id
  name    = format("%s-sde-research-%s-plan", local.environment[terraform.workspace], lower(each.value))

  disabled = var.plan_trigger_disabled
  filename = format("%s-plan.yaml", "cloudbuild/deployments/researcher-workspace-project")
  included_files = [
    format("environment/deployments/researcher-projects/env/%s/egress/%s.tfvars", each.value, local.included_files),
    format("environment/deployments/researcher-projects/env/%s/workspace/%s.tfvars", each.value, local.included_files),
    format("environment/deployments/researcher-projects/env/%s/vpc-sc/%s.tfvars", each.value, local.included_files),
    format("environment/deployments/researcher-projects/env/%s/globals.tfvars", each.value)
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
    _BUCKET            = local.terraform_state_bucket
    _PREFIX            = "deployments"
    _PREFIX_FOUNDATION = format("%s", local.terraform_foundation_state_prefix)
    _TAG               = local.terraform_container_version
    _TFVARS_FILE       = local.included_files
    _WORKSPACE         = each.value
  }
}

