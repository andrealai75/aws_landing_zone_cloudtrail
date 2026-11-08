output "organization_id" {
  value = data.aws_organizations_organization.current.id
}

output "aws_management_account_id" {
  value = var.aws_management_account_id
}

output "security_log_account_id" {
  value = var.security_log_account_id
}

output "security_tooling_account_id" {
  value = var.security_tooling_account_id
}

output "s3_bucket_name" {
  value = local.s3_bucket_name
}
