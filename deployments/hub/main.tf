resource "azurerm_resource_group" "this" {
  location = "UK South"
  name     = "rg-hub-uks"

}

resource "azurerm_virtual_network" "this" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = "vnet-hub-uks"
  resource_group_name = azurerm_resource_group.this.name
  subnet {
    address_prefix = "10.0.1.0/24"
    name           = "GatewaySubnet"
  }
  subnet {
    address_prefix = "10.0.2.0/24"
    name           = "AzureFirewallSubnet"
  }
  subnet {
    address_prefix = "10.0.3.0/24"
    name           = "AzureBastionSubnet"
  }
}

resource "azurerm_public_ip" "firewall" {
  count = var.firewall_enabled ? 1 : 0

  name                = "pip-hub-uks"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "this" {
  count = var.firewall_enabled ? 1 : 0

  name                = "fw-hub-uks"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = tolist(azurerm_virtual_network.this.subnet).1.id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

resource "azurerm_public_ip" "bastion" {
  count = var.bastion_enabled ? 1 : 0

  name                = "pip-hub-uks"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "this" {
  count = var.bastion_enabled ? 1 : 0

  name                = "bastion-hub-uks"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = tolist(azurerm_virtual_network.this.subnet).2.id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}

module "write_data" {
  source                     = "./../../modules/terraform-azurerm-app-configuration-read-write"
  
  read_or_write              = "write"
  app_configuration_store_id = var.app_configuration_store_id
  key                        = "hub_virtual_network_id"
  value                      = azurerm_virtual_network.this.id

}
