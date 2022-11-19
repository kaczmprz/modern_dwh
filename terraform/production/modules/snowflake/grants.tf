resource "snowflake_database_grant" "retail_db_usage" {
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
  shares            = [snowflake_share.share_company_name_x.name]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_role.role, snowflake_share.share_company_name_x]
}

resource "snowflake_schema_grant" "sales_schema_usage" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["SALES"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["SALES_ANALYST"].name, snowflake_role.role["SALES_SUPERUSER"].name]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_schema.schema, snowflake_role.role, snowflake_share.share_company_name_x,
                      snowflake_database_grant.retail_db_usage]
}

resource "snowflake_schema_grant" "finance_schema_usage" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["FINANCE"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["FINANCE_ANALYST"].name, snowflake_role.role["FINANCE_SUPERUSER"].name]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_schema.schema, snowflake_role.role, snowflake_share.share_company_name_x,
                      snowflake_database_grant.retail_db_usage]
}

resource "snowflake_schema_grant" "warehouse_schema_usage" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["WAREHOUSE"].name
  privilege         = "USAGE"
  roles             = [snowflake_role.role["WAREHOUSE_ANALYST"].name, snowflake_role.role["WAREHOUSE_SUPERUSER"].name]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_schema.schema, snowflake_role.role, snowflake_share.share_company_name_x,
                      snowflake_database_grant.retail_db_usage]
}

resource "snowflake_schema_grant" "prod_schema_usage" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["PROD"].name
  privilege         = "USAGE"
  shares            = [snowflake_share.share_company_name_x.name]
  with_grant_option = false
  depends_on        = [snowflake_database.database, snowflake_schema.schema, snowflake_role.role,
                      snowflake_share.share_company_name_x, snowflake_database_grant.retail_db_usage]
}

resource "snowflake_warehouse_grant" "compute_wh_usage" {
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

resource "snowflake_integration_grant" "s3_integration_usage" {
  provider          = snowflake.account_admin
  integration_name  = "s3"
  privilege         = "USAGE"
  roles             = ["SYSADMIN"]
  with_grant_option = false
  depends_on        = [snowflake_storage_integration.s3]
}

resource "snowflake_table_grant" "share_company_name_x_tables" {
  provider          = snowflake.account_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["PROD"].name
  table_name        = snowflake_table.table["DIM_PRODUCT"].name
  privilege         = "SELECT"
  shares            = [snowflake_share.share_company_name_x.name]
  depends_on        = [snowflake_database_grant.retail_db_usage, snowflake_schema_grant.prod_schema_usage]
}
