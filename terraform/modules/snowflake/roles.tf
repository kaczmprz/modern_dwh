locals {
  roles = {
    "ANALYST" = {
      comment  = "Data analyst role"
    }
  }
}

resource "snowflake_role" "role" {
  for_each   = local.roles
  provider   = snowflake.security_admin
  name       = each.key
  comment    = each.value.comment
}


