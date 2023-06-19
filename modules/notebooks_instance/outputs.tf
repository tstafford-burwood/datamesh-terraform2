output "notebook_instances" {
  description = "A list of notebooks created (vm names)"
  value       = [for nb in google_notebooks_instance.instance : nb.name]
}

output "user_proxy_uri" {
  description = "A map of user to their proxy uri."
  value       = { for i in google_notebooks_instance.instance : i.instance_owners[0] => i.proxy_uri }
}

output "user_instance" {
  description = "A map of user to instance."
  value       = { for i in google_notebooks_instance.instance : i.instance_owners[0] => i.name }
}