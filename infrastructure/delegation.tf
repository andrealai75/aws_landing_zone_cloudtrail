resource "aws_organizations_delegated_administrator" "cloudtrail_admin" {
  provider          = aws.management_root
  account_id        = var.security_tooling_account_id
  service_principal = "cloudtrail.amazonaws.com"
}

resource "aws_iam_service_linked_role" "cloudtrail" {
  provider         = aws.security_tooling
  aws_service_name = "cloudtrail.amazonaws.com"
}
