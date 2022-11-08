resource "snowflake_database_grant" "retail_analyst" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["SALES_ANALYST"].name,
                      snowflake_role.role["FINANCE_ANALYST"].name,
                      snowflake_role.role["WAREHOUSE_ANALYST"].name,
                      snowflake_role.role["SALES_SUPERUSER"].name,
                      snowflake_role.role["FINANCE_SUPERUSER"].name,
                      snowflake_role.role["WAREHOUSE_SUPERUSER"].name,
                      ]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_role.role]
}

resource "snowflake_schema_grant" "retail_sales_analyst" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["SALES"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["SALES_ANALYST"].name]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_schema.schema, snowflake_role.role]
}

resource "snowflake_warehouse_grant" "compute_wh_analyst" {
  provider          = snowflake.security_admin
  warehouse_name    = snowflake_warehouse.warehouse["COMPUTE_WH"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["SALES_ANALYST"].name,
                      snowflake_role.role["FINANCE_ANALYST"].name,
                      snowflake_role.role["WAREHOUSE_ANALYST"].name,
                      snowflake_role.role["SALES_SUPERUSER"].name,
                      snowflake_role.role["FINANCE_SUPERUSER"].name,
                      snowflake_role.role["WAREHOUSE_SUPERUSER"].name,
                      ]
  with_grant_option = false
  depends_on        = [snowflake_warehouse.warehouse, snowflake_role.role]
}

resource "snowflake_integration_grant" "s3_integration_sysadmin" {
  provider          = snowflake.account_admin
  integration_name  = "s3"
  privilege         = "USAGE"
  roles             = ["SYSADMIN"]
  with_grant_option = false
  depends_on        = [snowflake_storage_integration.s3]
}
/*
resource "snowflake_stage_grant" "stage_orders_sysadmin" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["SALES"].name
  stage_name        = "stage_orders"
  privilege         = "USAGE"
  roles             = ["SYSADMIN"]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_schema.schema, snowflake_stage.stage_orders]
}
*/