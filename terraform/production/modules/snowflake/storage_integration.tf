resource "snowflake_storage_integration" "s3" {
  provider = snowflake.account_admin
  name    = "s3"
  comment = "A storage integration."
  type    = "EXTERNAL_STAGE"
  enabled = true
  storage_allowed_locations = ["s3://${var.bucket_name}/"]
  storage_provider         = "S3"
  storage_aws_role_arn     = var.aws_storage_aws_role_arn
}