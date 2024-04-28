resource "azurerm_resource_group" "this" {
  name     = "rg-app-configuration-store-uks"
  location = "UK South"
}

resource "random_bytes" "this" {
  length = 4
}

resource "azurerm_app_configuration" "this" {
  name                = "appcs-${random_bytes.this.hex}-uks"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_role_assignment" "this" {
  scope                = azurerm_app_configuration.this.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
