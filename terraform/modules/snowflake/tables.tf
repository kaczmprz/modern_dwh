locals {
  tables = {
    "CUSTOMER" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["STAGE"].name
      comment     = "Staging customer table"
      change_tracking = false
      columns = {
        NAME = {
          type     = "varchar(100)"
          nullable = true
        }
        BIRHT_DATE = {
          type     = "date"
          nullable = true
        }
        TOWN = {
          type     = "varchar(100)"
          nullable = true
        }
        EMAIL = {
          type     = "varchar(100)"
          nullable = true
        }
      }
    }
    "PRODUCT" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["STAGE"].name
      comment     = "Staging product table"
      change_tracking = false
      columns = {
        EAN = {
          type     = "number(38,0)"
          nullable = true
        }
        CATEGORY = {
          type     = "varchar(100)"
          nullable = true
        }
        NET_PRICE = {
          type     = "number(38,2)"
          nullable = true
        }
      }
    }
    "SHOPS" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["STAGE"].name
      comment     = "Staging shops table"
      change_tracking = false
      columns = {
        ID = {
          type     = "number(38,0)"
          nullable = true
        }
        CITY = {
          type     = "varchar(100)"
          nullable = true
        }
      }
    }
    "ORDERS" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["STAGE"].name
      comment     = "Staging orders table"
      change_tracking = false
      columns = {
        JSON = {
          type     = "VARIANT"
          nullable = false
        }
      }
    }
  }
}



resource "snowflake_table" "table" {
  for_each    = local.tables
  provider    = snowflake.sysadmin
  name        = each.key
  database    = each.value.database
  schema      = each.value.schema
  comment     = each.value.comment
  change_tracking = each.value.change_tracking
  dynamic "column" {
    for_each = each.value.columns
    content {
      name     = column.key
      type     = column.value["type"]
      nullable = column.value["nullable"]
    }
  }
}