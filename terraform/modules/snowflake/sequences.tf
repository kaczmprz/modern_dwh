locals {
  sequences = {
    "seq_customer" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["PROD"].name
      comment     = "Sequence for customer table primary key"
    }
    "seq_orders" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["PROD"].name
      comment     = "Sequence for orders table primary key"
    }
    "seq_product" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["PROD"].name
      comment     = "Sequence for product table primary key"
    }
    "seq_shops" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["PROD"].name
      comment     = "Sequence for shops table primary key"
    }
  }
}

resource "snowflake_sequence" "sequence" {
  for_each    = local.sequences
  provider    = snowflake.sysadmin
  name        = each.key
  database    = each.value.database
  schema      = each.value.schema
  comment     = each.value.comment
}