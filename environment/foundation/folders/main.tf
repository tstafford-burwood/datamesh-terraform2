#------------------------------------------------------------------------
# IMPORT CONSTANTS
#------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

#------------------------------------------------------------------------
# SET LOCALS
#------------------------------------------------------------------------

locals {
  #suffix           = var.suffix == "" ? "" : "-${var.suffix}"
  parent_folder_id = format("%s/%s", "folders", module.constants.value.sde_folder_id)
  environment      = module.constants.value.environment
}

#----------------------------------------------------------------------------
# SETUP FOLDER STRUCTURE
#----------------------------------------------------------------------------

resource "google_folder" "environment" {
  # Parent Folder
  display_name = format("%s-%s", var.folder_name, local.environment[terraform.workspace])
  parent       = local.parent_folder_id
}

# Researcher Workspace Folders
resource "google_folder" "researcher_workspaces" {
  for_each     = toset(var.researcher_workspace_folders)
  display_name = each.value
  parent       = google_folder.environment.name
}

resource "google_folder_iam_audit_config" "config" {
  # Allow management of audit logging config for a given service for a GCP folder
  count   = length(var.audit_log_config)
  folder  = google_folder.environment.name
  service = var.audit_service
  dynamic "audit_log_config" {
    for_each = length(var.audit_log_config) > 0 ? toset(var.audit_log_config) : []
    content {
      log_type = audit_log_config.value
    }
  }
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"

  depends_on = [
    google_folder.environment,
    google_folder.researcher_workspaces
  ]
}