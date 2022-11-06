resource "snowflake_pipe" "pipe" {
  provider    = snowflake.sysadmin
  database    = snowflake_database.database["RETAIL"].name
  schema      = snowflake_schema.schema["STAGE"].name
  name        = "pipe"
  comment     = "A pipe for loading orders data"
  copy_statement = "copy into retail.stage.orders from @retail.stage.mystage file_format = (type = 'JSON')"
  auto_ingest    = true
}

resource "snowflake_pipe" "pipe2" {
  provider    = snowflake.account_admin
  database    = snowflake_database.database["RETAIL"].name
  schema      = snowflake_schema.schema["STAGE"].name
  name        = "pipe2"
  comment     = "A pipe for loading orders data"
  copy_statement = "copy into retail.stage.orders2 from @retail.stage.mystage2 file_format = (type = 'JSON')"
  auto_ingest    = true
}
