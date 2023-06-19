#-------------------------
# CLOUD DNS MODULE OUTPUTS
#-------------------------

output "type" {
  description = "The DNS zone type."
  value       = module.cloud-dns.type
}

output "name" {
  description = "The DNS zone name."
  value       = module.cloud-dns.name
}

output "domain" {
  description = "The DNS zone domain."
  value       = module.cloud-dns.domain
}

output "name_servers" {
  description = "The DNS zone name servers."
  value       = module.cloud-dns.name_servers
}