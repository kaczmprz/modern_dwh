locals {
  roles = {
    "SALES_ANALYST" = {
      comment  = "Sales data analyst role"
    }
    "FINANCE_ANALYST" = {
      comment  = "Financial data analyst role"
    }
    "WAREHOUSE_ANALYST" = {
      comment  = "Warehouse data analyst role"
    }
    "SALES_SUPERUSER" = {
      comment  = "Sales data superuser role"
    }
    "FINANCE_SUPERUSER" = {
      comment  = "Financial data superuser role"
    }
    "WAREHOUSE_SUPERUSER" = {
      comment  = "Warehouse data superuser role"
    }
  }
}

resource "snowflake_role" "role" {
  for_each   = local.roles
  provider   = snowflake.user_admin
  name       = each.key
  comment    = each.value.comment
}

