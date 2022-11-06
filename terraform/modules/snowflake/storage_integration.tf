resource "snowflake_storage_integration" "s32" {
  provider    = snowflake.account_admin
  name    = "s32"
  comment = "A storage integration."
  type    = "EXTERNAL_STAGE"
  enabled = true
  storage_allowed_locations = ["s3://mdw-staging/"]
  storage_provider         = "S3"
  storage_aws_role_arn     = "arn:aws:iam::410599452757:role/mysnowflakerole2"
}