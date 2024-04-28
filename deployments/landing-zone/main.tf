module "hub_virtual_network_id" {
  source = "./../../modules/terraform-azurerm-app-configuration-read-write"

  read_or_write              = "read"
  app_configuration_store_id = var.app_configuration_store_id
  key                        = "hub_virtual_network_id"
}

resource "azurerm_resource_group" "this" {
  location = "UK South"
  name     = "rg-landing-zone-uks"

}

resource "azurerm_virtual_network" "this" {
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = "vnet-landing-zone-uks"
  resource_group_name = azurerm_resource_group.this.name
  subnet {
    address_prefix = "10.2.1.0/24"
    name           = "snet-app-uks"
  }
}

resource "azurerm_virtual_network_peering" "hub_to_landing_zone" {
  name                      = "hub-to-landing-zone"
  resource_group_name       = split("/", module.hub_virtual_network_id.value)[4]
  virtual_network_name      = split("/", module.hub_virtual_network_id.value)[8]
  remote_virtual_network_id = azurerm_virtual_network.this.id
}

resource "azurerm_virtual_network_peering" "landing_zone_to_hub" {
  name                      = "landing-zone-to-hub"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = module.hub_virtual_network_id.value
}
