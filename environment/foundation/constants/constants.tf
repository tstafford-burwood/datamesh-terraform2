#-----------------
# CONSTANT VALUES
#-----------------
locals {
  constants = {

    // DOMAIN INFORMATION
    automation_project_id      = "<PROJECT_ID>" # Project ID that hosts Cloud Build
    billing_account_id         = "000000-111111-222222"             
    cloudbuild_service_account = "<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com" # Cloud Build
    org_id                     = "012345678901" # gcloud organizations list
    sde_folder_id              = "012345678901"
    terraform_state_bucket     = "<TERRAFORM_STATE_BUCKET>"

    // USERS & GROUPS TO ASSIGN TO THE FOUNDATION PROJECTS
    // format: `user:user1@client.edu`, `group:admins@client.edu`, or `serviceAccount:my-app@appspot.gserviceaccount.com`
    ingress-project-admins = ["group:gcp_security_admins@example.com"]
    image-project-admins   = ["group:gcp_security_admins@example.com"]
    data-lake-admins       = ["group:gcp_security_admins@example.com"]
    data-lake-viewers      = ["group:gcp_security_admins@example.com"]
    data-ops-admins        = ["group:gcp_security_admins@example.com"]

    // Default Location
    default_region = "us-central1"

    // BRANCH IN VSC
    // Long running Branches. These need to match the branch names in Version Control Software.
    environment = {
      # <branch_name> = <environment_value>
      # Example: main = "prod"
      main = "prod"
    }
  }
}
