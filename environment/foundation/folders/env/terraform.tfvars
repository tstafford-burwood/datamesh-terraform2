# ---------------------------------------------------------
# CHANGE THE BELOW VALUES 
# To get Google Workspace customer IDS: gcloud organizations list
# ---------------------------------------------------------  

domain_restricted_sharing_allow   = ["<CLIENT_ID>"] # gcloud organizations list
researcher_workspace_folders      = ["workspace-1"]

audit_log_config = ["DATA_READ", "DATA_WRITE", "ADMIN_READ"]
