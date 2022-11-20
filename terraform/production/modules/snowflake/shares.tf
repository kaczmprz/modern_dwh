resource "snowflake_share" "share_company_name_x" {
  provider = snowflake.account_admin
  name     = "SHARE_COMPANY_NAME_X"
  comment  = "Datashare for company x"
}
