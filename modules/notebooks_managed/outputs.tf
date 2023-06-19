output "proxy_uri" {
  description = "The proxy endpoint that is used to access the runtime."
  value       = { for k in google_notebooks_runtime.managed : k.access_config[0].proxy_uri => k.access_config[0].runtime_owner }
}