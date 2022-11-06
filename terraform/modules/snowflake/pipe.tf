resource "snowflake_pipe" "pipe" {
  provider    = snowflake.sysadmin
  database    = snowflake_database.database["RETAIL"].name
  schema      = snowflake_schema.schema["STAGE"].name
  name        = "pipe"
  comment     = "A pipe for loading orders data"
  copy_statement = "copy into retail.stage.orders from @retail.stage.mystage file_format = (type = 'JSON')"
  auto_ingest    = true
}
