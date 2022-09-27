terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.45.0"
    }
  }
}

provider "snowflake" {
  alias = "sysadmin"
  role  = "SYSADMIN"
}

provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
}

resource "snowflake_database" "retail" {
  provider  = snowflake.sysadmin
  name      = "RETAIL"
  comment   = "Production data warehouse"
}

resource "snowflake_warehouse" "load_wh" {
  provider       = snowflake.sysadmin
  name           = "LOAD_WH"
  warehouse_size = "xsmall"
  comment        = "Virtual Warehouse for data loading"
  auto_suspend = 60
}

resource "snowflake_warehouse" "compute_wh" {
  provider       = snowflake.sysadmin
  name           = "COMPUTE_WH"
  warehouse_size = "xsmall"
  comment        = "Virtual Warehouse for data processing"
  auto_suspend = 60
}

resource "snowflake_role" "analyst" {
  provider = snowflake.security_admin
  name     = "ANALYST"
  comment  = "A data analyst role"
}

resource "snowflake_database_grant" "retail_analyst" {
  provider  = snowflake.security_admin
  database_name = snowflake_database.retail.name
  privilege = "USAGE"
  roles = [snowflake_role.analyst.name]
  with_grant_option = false
}

resource "snowflake_schema" "stage" {
  provider   = snowflake.sysadmin
  database   = snowflake_database.retail.name
  name       = "STAGE"
  is_managed = true
  comment    = "Staging area"
}

resource "snowflake_schema" "prod" {
  provider   = snowflake.sysadmin
  database   = snowflake_database.retail.name
  name       = "PROD"
  is_managed = true
  comment    = "Production area"
}

resource "snowflake_schema" "sales" {
  provider   = snowflake.sysadmin
  database   = snowflake_database.retail.name
  name       = "SALES"
  is_managed = true
  comment    = "Sales data area"
}

resource "snowflake_schema_grant" "retail_sales_analyst" {
  provider  = snowflake.security_admin
  database_name = snowflake_database.retail.name
  schema_name   = snowflake_schema.sales.name
  privilege = "USAGE"
  roles = [snowflake_role.analyst.name]
  with_grant_option = false
}

resource "snowflake_stage" "mdw_staging" {
  provider    = snowflake.sysadmin
  name        = "mdw_staging"
  url         = "s3://mdw-staging/"
  database    = snowflake_database.retail.name
  schema      = snowflake_schema.stage.name
  credentials = "AWS_KEY_ID='${var.aws_access_key}' AWS_SECRET_KEY='${var.aws_secret_key}'"
}


resource "snowflake_warehouse_grant" "compute_wh_analyst" {
  provider  = snowflake.security_admin
  warehouse_name= snowflake_warehouse.compute_wh.name
  privilege = "USAGE"
  roles = [snowflake_role.analyst.name]
  with_grant_option = false
}

resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

