resource "google_folder" "parent" {
  # Create top level folder under another folder or organization. Default is org
  display_name = format("%s", upper(var.folder_name))
  parent       = local.parent
}