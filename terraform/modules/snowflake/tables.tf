locals {
  tables = {
    "CUSTOMER" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["STAGE"].name
      comment     = "Staging customer table"
      change_tracking = false
      columns = {
        NAME = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        BIRTH_DATE = {
          type     = "DATE"
          nullable = true
        }
        TOWN = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        EMAIL = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        FILENAME = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        LOAD_TS = {
          type     = "TIMESTAMP_NTZ(9)"
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
          type     = "NUMBER(38,0)"
          nullable = true
        }
        CATEGORY = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        NET_PRICE = {
          type     = "NUMBER(38,2)"
          nullable = true
        }
        FILENAME = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        LOAD_TS = {
          type     = "TIMESTAMP_NTZ(9)"
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
          type     = "NUMBER(38,0)"
          nullable = true
        }
        CITY = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        FILENAME = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        LOAD_TS = {
          type     = "TIMESTAMP_NTZ(9)"
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
    "DIM_CUSTOMER" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["PROD"].name
      comment     = "Production customer table"
      change_tracking = false
      columns = {
        PK = {
          type     = "NUMBER(38,0)"
          nullable = false
        }
        NAME = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        BIRTH_DATE = {
          type     = "DATE"
          nullable = true
        }
        TOWN = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        EMAIL = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        IS_VALID = {
          type     = "BOOLEAN"
          nullable = false
        }
        VALID_FROM = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        VALID_TO = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        MODIFICATION_TS = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        HASH = {
          type     = "NUMBER(38,0)"
          nullable = true
        }
      }
    }
    "DIM_PRODUCT" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["PROD"].name
      comment     = "Production product table"
      change_tracking = false
      columns = {
        PK = {
          type     = "NUMBER(38,0)"
          nullable = false
        }
        EAN = {
          type     = "NUMBER(38,0)"
          nullable = true
        }
        CATEGORY = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        NET_PRICE = {
          type     = "NUMBER(38,2)"
          nullable = true
        }
        IS_VALID = {
          type     = "BOOLEAN"
          nullable = false
        }
        VALID_FROM = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        VALID_TO = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        MODIFICATION_TS = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        HASH = {
          type     = "NUMBER(38,0)"
          nullable = true
        }
      }
    }
    "DIM_SHOPS" = {
      database    = snowflake_database.database["RETAIL"].name
      schema      = snowflake_schema.schema["PROD"].name
      comment     = "Production shops table"
      change_tracking = false
      columns = {
        PK = {
          type     = "NUMBER(38,0)"
          nullable = false
        }
        ID = {
          type     = "NUMBER(38,0)"
          nullable = true
        }
        CITY = {
          type     = "VARCHAR(100)"
          nullable = true
        }
        IS_VALID = {
          type     = "BOOLEAN"
          nullable = false
        }
        VALID_FROM = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        VALID_TO = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        MODIFICATION_TS = {
          type     = "TIMESTAMP_NTZ(9)"
          nullable = false
        }
        HASH = {
          type     = "NUMBER(38,0)"
          nullable = true
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