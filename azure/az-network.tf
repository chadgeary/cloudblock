resource "azurerm_virtual_network" "ph-network" {
  name                    = "${var.ph_prefix}-network"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  address_space           = [var.az_network_cidr]
  dns_servers             = [var.az_dns1, var.az_dns2]
  subnet {
    name                    = "${var.ph_prefix}-subnet1"
    address_prefix          = var.az_subnet_cidr
  }
}

resource "azurerm_public_ip" "ph-public-ip" {
  name                    = "${var.ph_prefix}-public-ip"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  sku                     = "Basic"
  allocation_method       = "Static"
}
