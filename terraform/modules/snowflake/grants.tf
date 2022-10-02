resource "snowflake_database_grant" "retail_analyst" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["ANALYST"].name]
  with_grant_option = false
}

resource "snowflake_schema_grant" "retail_sales_analyst" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["SALES"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["ANALYST"].name]
  with_grant_option = false
}

resource "snowflake_warehouse_grant" "compute_wh_analyst" {
  provider          = snowflake.security_admin
  warehouse_name    = snowflake_warehouse.warehouse["COMPUTE_WH"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["ANALYST"].name]
  with_grant_option = false
}