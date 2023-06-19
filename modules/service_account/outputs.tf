#------------------------
# SERVICE ACCOUNT OUTPUTS
#------------------------

output "email" {
  description = "The service account email."
  value       = module.service_account.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.service_account.iam_email
}

output "service_account" {
  description = "Service account resource (for single use)."
  value       = module.service_account.service_account
}

output "service_accounts" {
  description = "Service account resources as list."
  value       = module.service_account.service_accounts
}