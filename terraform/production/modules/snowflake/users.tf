resource "snowflake_user" "analyst1" {
  provider     = snowflake.user_admin
  name         = "Snowflake User1"
  login_name   = "analyst1"
  password     = "analyst1"
  comment      = "A user of snowflake."
  display_name = "Snowflake User1"
  first_name   = "Snowflake"
  last_name    = "User"
}

resource "snowflake_user" "analyst2" {
  provider     = snowflake.user_admin
  name         = "Snowflake User2"
  login_name   = "analyst2"
  password     = "analyst2"
  comment      = "A user of snowflake."
  display_name = "Snowflake User2"
  first_name   = "Snowflake"
  last_name    = "User"
}

resource "snowflake_user" "analyst3" {
  provider     = snowflake.user_admin
  name         = "Snowflake User3"
  login_name   = "analyst3"
  password     = "analyst3"
  comment      = "A user of snowflake."
  display_name = "Snowflake User3"
  first_name   = "Snowflake"
  last_name    = "User"
}

resource "snowflake_user" "analyst4" {
  provider     = snowflake.user_admin
  name         = "Snowflake User4"
  login_name   = "analyst4"
  password     = "analyst4"
  comment      = "A user of snowflake."
  display_name = "Snowflake User4"
  first_name   = "Snowflake"
  last_name    = "User"
}