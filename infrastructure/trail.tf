resource "aws_cloudtrail" "main_trail" {
  provider                      = aws.security_tooling
  name                          = "organization-security-trail"
  s3_bucket_name                = aws_s3_bucket.main.id
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [
    aws_s3_bucket_policy.main,
    aws_iam_service_linked_role.cloudtrail
  ]
}
