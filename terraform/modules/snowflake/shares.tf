resource "snowflake_share" "myfirstshare" {
  provider = snowflake.account_admin
  name     = "myfirstshare"
  comment  = "cool comment"
  #accounts = ["organizationName.accountName"]
}

resource "snowflake_database_grant" "myfirstshregrantdb" {
  provider          = snowflake.account_admin
  database_name     = snowflake_database.database["RETAIL"].name
  privilege         = "USAGE"
  shares            = [snowflake_share.myfirstshare.name]
}

resource "snowflake_schema_grant" "myfirstshregrantschema" {
  provider          = snowflake.account_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["PROD"].name
  privilege         = "USAGE"
  shares            = [snowflake_share.myfirstshare.name]
  depends_on        = [snowflake_database_grant.myfirstshregrantdb]
}

resource "snowflake_table_grant" "myfirstshregranttable" {
  provider          = snowflake.account_admin
  database_name     = snowflake_database.database["RETAIL"].name
  schema_name       = snowflake_schema.schema["PROD"].name
  table_name        = snowflake_table.table["DIM_PRODUCT"].name
  privilege         = "SELECT"
  shares            = [snowflake_share.myfirstshare.name]
  depends_on        = [snowflake_database_grant.myfirstshregrantdb, snowflake_schema_grant.myfirstshregrantschema]
}