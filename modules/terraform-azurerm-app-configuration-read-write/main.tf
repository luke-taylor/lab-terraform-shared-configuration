resource "azurerm_app_configuration_key" "this" {
  count                  = var.read_or_write == "write" ? 1 : 0
  configuration_store_id = var.app_configuration_store_id
  key                    = var.key
  label                  = var.label
  value                  = jsonencode(var.value)
  tags                   = var.tags

  lifecycle {
    precondition {
      condition     = var.read_or_write == "write" && var.value == null ? false : true
      error_message = "The value must be set when writing a key."
    }
  }
}
