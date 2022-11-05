resource "snowflake_role_grants" "sales_superuser_grants" {
  provider   = snowflake.security_admin
  role_name = "SALES_SUPERUSER"
  roles = [
    "SYSADMIN",
  ]
}


resource "snowflake_role_grants" "finance_superuser_grants" {
  provider   = snowflake.security_admin
  role_name = "FINANCE_SUPERUSER"
  roles = [
    "SYSADMIN",
  ]
}


resource "snowflake_role_grants" "warehouse_superuser_grants" {
  provider   = snowflake.security_admin
  role_name = "WAREHOUSE_SUPERUSER"
  roles = [
    "SYSADMIN",
  ]
}

resource "snowflake_role_grants" "sales_analyst_grants" {
  provider   = snowflake.security_admin
  role_name = "SALES_ANALYST"
  roles = [
    "SYSADMIN","SALES_SUPERUSER"
  ]
}


resource "snowflake_role_grants" "finance_analyst_grants" {
  provider   = snowflake.security_admin
  role_name = "FINANCE_ANALYST"
  roles = [
    "SYSADMIN","FINANCE_SUPERUSER"
  ]
}


resource "snowflake_role_grants" "warehouse_analyst_grants" {
  provider   = snowflake.security_admin
  role_name = "WAREHOUSE_ANALYST"
  roles = [
    "SYSADMIN","WAREHOUSE_SUPERUSER"
  ]
}