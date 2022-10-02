locals {
  warehouses = {
    "LOAD_WH" = {
      warehouse_size = "xsmall"
      comment        = "Virtual Warehouse for data loading"
      auto_suspend   = 60
    }
    "COMPUTE_WH" = {
      warehouse_size = "xsmall"
      comment        = "Virtual Warehouse for data processing"
      auto_suspend   = 60
    }
  }
}

resource "snowflake_warehouse" "warehouse" {
  for_each       = local.warehouses
  provider       = snowflake.sysadmin
  name           = each.key
  warehouse_size = each.value.warehouse_size
  comment        = each.value.comment
  auto_suspend   = each.value.auto_suspend
}
