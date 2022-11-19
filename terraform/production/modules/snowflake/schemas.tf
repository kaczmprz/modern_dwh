locals {
  schemas = {
    "STAGE" = {
      database   = snowflake_database.database["RETAIL"].name
      comment    = "Staging area"
      is_managed = true
    }
    "PROD" = {
      database   = snowflake_database.database["RETAIL"].name
      comment    = "Production area"
      is_managed = true
    }
    "SALES" = {
      database   = snowflake_database.database["RETAIL"].name
      comment    = "Sales data area"
      is_managed = true
    }
  }
}

resource "snowflake_schema" "schema" {
  for_each   = local.schemas
  provider   = snowflake.sysadmin
  name       = each.key
  database   = each.value.database
  comment    = each.value.comment
  is_managed = each.value.is_managed
}
