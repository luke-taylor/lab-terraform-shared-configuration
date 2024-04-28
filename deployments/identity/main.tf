module "hub_virtual_network_id" {
  source = "./../../modules/terraform-azurerm-app-configuration-read-write"

  read_or_write              = "read"
  app_configuration_store_id = var.app_configuration_store_id
  key                        = "hub_virtual_network_id"
}

resource "azurerm_resource_group" "this" {
  location = "UK South"
  name     = "rg-identity-uks"

}

resource "azurerm_virtual_network" "this" {
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = "vnet-identity-uks"
  resource_group_name = azurerm_resource_group.this.name
  subnet {
    address_prefix = "10.1.1.0/24"
    name           = "snet-identity-uks"
  }
}

resource "azurerm_virtual_network_peering" "hub_to_identity" {
  name                      = "hub-to-identity"
  resource_group_name       = split("/", module.hub_virtual_network_id.value)[4]
  virtual_network_name      = split("/", module.hub_virtual_network_id.value)[8]
  remote_virtual_network_id = azurerm_virtual_network.this.id
}

resource "azurerm_virtual_network_peering" "identity_to_hub" {
  name                      = "identity-to-hub"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = module.hub_virtual_network_id.value
}

resource "azurerm_private_dns_zone" "this" {
  name                = "contoso.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_to_identity" {
  name                  = "link-to-identity"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_to_hub" {
  name                  = "link-to-hub"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = module.hub_virtual_network_id.value
}
