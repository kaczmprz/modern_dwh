resource "time_sleep" "wait_15_seconds" {
  depends_on = [snowflake_stage.stage_orders]
  create_duration = "15s"
}

resource "snowflake_pipe" "pipe_orders" {
  provider       = snowflake.sysadmin
  database       = snowflake_database.database["RETAIL"].name
  schema         = snowflake_schema.schema["STAGE"].name
  name           = "pipe_orders"
  comment        = "A pipe for loading orders data"
  copy_statement = "copy into retail.stage.orders from @retail.stage.stage_orders file_format = (type = 'JSON')"
  auto_ingest    = true
  depends_on     = [time_sleep.wait_15_seconds, snowflake_stage.stage_orders, snowflake_table.table]
}
