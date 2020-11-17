resource "azurerm_virtual_network" "ph-network" {
  name                    = "${var.ph_prefix}-network"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  address_space           = [var.az_network_cidr]
}

resource "azurerm_subnet" "ph-subnet" {
  name                    = "${var.ph_prefix}-subnet"
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  virtual_network_name    = azurerm_virtual_network.ph-network.name
  address_prefixes        = [var.az_subnet_cidr]
}

resource "azurerm_public_ip" "ph-public-ip" {
  name                    = "${var.ph_prefix}-public-ip"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  sku                     = "Basic"
  allocation_method       = "Static"
}

resource "azurerm_network_security_group" "ph-net-sec" {
  name                    = "${var.ph_prefix}-net-sec"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
}

resource "azurerm_subnet_network_security_group_association" "ph-net-sec-assoc" {
  subnet_id                   = azurerm_subnet.ph-subnet.id
  network_security_group_id   = azurerm_network_security_group.ph-net-sec.id
}

resource "azurerm_network_security_rule" "ph-net-rule-ssh" {
  name                         = "${var.ph_prefix}-net-rule-ssh"
  resource_group_name          = azurerm_resource_group.ph-resourcegroup.name
  network_security_group_name  = azurerm_network_security_group.ph-net-sec.name
  priority                     = 100
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "22"
  
  source_address_prefix        = var.mgmt_cidr
  destination_address_prefixes = [var.az_subnet_cidr]
} 

resource "azurerm_network_security_rule" "ph-net-rule-https" {
  name                         = "${var.ph_prefix}-net-rule-https"
  resource_group_name          = azurerm_resource_group.ph-resourcegroup.name
  network_security_group_name  = azurerm_network_security_group.ph-net-sec.name
  priority                     = 101
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "443"
  source_address_prefix        = var.mgmt_cidr
  destination_address_prefixes = [var.az_subnet_cidr]
}

resource "azurerm_network_security_rule" "ph-net-rule-wireguard" {
  name                         = "${var.ph_prefix}-net-rule-wireguard"
  resource_group_name          = azurerm_resource_group.ph-resourcegroup.name
  network_security_group_name  = azurerm_network_security_group.ph-net-sec.name
  priority                     = 102
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Udp"
  source_port_range            = "*"
  destination_port_range       = "51820"
  source_address_prefix        = "0.0.0.0/0"
  destination_address_prefixes = [var.az_subnet_cidr]
}

resource "azurerm_network_security_rule" "ph-net-rule-dnstcp" {
  count                        = var.dns_novpn * 1
  name                         = "${var.ph_prefix}-net-rule-dnstcp"
  resource_group_name          = azurerm_resource_group.ph-resourcegroup.name
  network_security_group_name  = azurerm_network_security_group.ph-net-sec.name
  priority                     = 200
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "53"
  source_address_prefix        = var.mgmt_cidr
  destination_address_prefixes = [var.az_subnet_cidr]
}

resource "azurerm_network_security_rule" "ph-net-rule-dnsudp" {
  count                        = var.dns_novpn * 1
  name                         = "${var.ph_prefix}-net-rule-dnsudp"
  resource_group_name          = azurerm_resource_group.ph-resourcegroup.name
  network_security_group_name  = azurerm_network_security_group.ph-net-sec.name
  priority                     = 201
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Udp"
  source_port_range            = "*"
  destination_port_range       = "53"
  source_address_prefix        = var.mgmt_cidr
  destination_address_prefixes = [var.az_subnet_cidr]
}

resource "azurerm_network_security_rule" "ph-net-rule-clients-dnstcp" {
  count                        = length(var.client_cidrs) == 0 ? 0 : 1
  name                         = "${var.ph_prefix}-net-rule-clients-dnstcp"
  resource_group_name          = azurerm_resource_group.ph-resourcegroup.name
  network_security_group_name  = azurerm_network_security_group.ph-net-sec.name
  priority                     = 202
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "53"
  source_address_prefixes      = var.client_cidrs
  destination_address_prefixes = [var.az_subnet_cidr]
}

resource "azurerm_network_security_rule" "ph-net-rule-clients-dnsudp" {
  count                        = length(var.client_cidrs) == 0 ? 0 : 1
  name                         = "${var.ph_prefix}-net-rule-clients-dnsudp"
  resource_group_name          = azurerm_resource_group.ph-resourcegroup.name
  network_security_group_name  = azurerm_network_security_group.ph-net-sec.name
  priority                     = 203
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Udp"
  source_port_range            = "*"
  destination_port_range       = "53"
  source_address_prefixes      = var.client_cidrs
  destination_address_prefixes = [var.az_subnet_cidr]
}
