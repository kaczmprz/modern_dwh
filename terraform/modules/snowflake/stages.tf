locals {
  stages = {
    "MDW_STAGING" = {
      url         = "s3://mdw-staging/"
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["STAGE"].name
      credentials = "AWS_KEY_ID='${var.aws_access_key}' AWS_SECRET_KEY='${var.aws_secret_key}'"
      comment     = "Production data warehouse"
    }
  }
}

resource "snowflake_stage" "stage" {
  for_each    = local.stages
  provider    = snowflake.sysadmin
  name        = each.key
  url         = each.value.url
  database    = each.value.database
  schema      = each.value.schema
  credentials = each.value.credentials
  comment     = each.value.comment
}