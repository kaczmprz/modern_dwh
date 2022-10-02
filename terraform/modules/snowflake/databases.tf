locals {
  databases = {
    "RETAIL" = {
      comment  = "Production data warehouse"
    }
  }
}

resource "snowflake_database" "database" {
  for_each   = local.databases
  provider   = snowflake.sysadmin
  name       = each.key
  comment    = each.value.comment
}