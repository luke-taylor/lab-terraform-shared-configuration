data "azurerm_app_configuration_key" "this" {
  count                  = var.read_or_write == "read" && var.key != "*" ? 1 : 0
  configuration_store_id = var.app_configuration_store_id
  key                    = var.key
  label                  = var.label
}

data "azurerm_app_configuration_keys" "this" {
  count                  = var.read_or_write == "read" && var.key == "*" ? 1 : 0
  configuration_store_id = var.app_configuration_store_id
  label                  = var.label
}
