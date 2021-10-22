resource "azurerm_virtual_network" "ph-network" {
  name                = "${var.ph_prefix}-network"
  location            = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name = azurerm_resource_group.ph-resourcegroup.name
  address_space       = [var.az_network_cidr]
}

resource "azurerm_subnet" "ph-subnet" {
  name                 = "${var.ph_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.ph-resourcegroup.name
  virtual_network_name = azurerm_virtual_network.ph-network.name
  address_prefixes     = [var.az_subnet_cidr]
}

resource "azurerm_public_ip" "ph-public-ip" {
  name                = "${var.ph_prefix}-public-ip"
  location            = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name = azurerm_resource_group.ph-resourcegroup.name
  sku                 = "Basic"
  allocation_method   = "Static"
}

resource "azurerm_subnet_network_security_group_association" "ph-net-sec-assoc-base" {
  count                     = var.dns_novpn + length(var.client_cidrs) == 0 ? 1 : 0
  subnet_id                 = azurerm_subnet.ph-subnet.id
  network_security_group_id = azurerm_network_security_group.ph-net-sec-base[count.index].id
}

resource "azurerm_subnet_network_security_group_association" "ph-net-sec-assoc-basednsclient" {
  count                     = var.dns_novpn + (length(var.client_cidrs) >= 1 ? 1 : 0) == 2 ? 1 : 0
  subnet_id                 = azurerm_subnet.ph-subnet.id
  network_security_group_id = azurerm_network_security_group.ph-net-sec-basednsclient[count.index].id
}

resource "azurerm_subnet_network_security_group_association" "ph-net-sec-assoc-basedns" {
  count                     = var.dns_novpn + (length(var.client_cidrs) == 0 ? 2 : 0) == 3 ? 1 : 0
  subnet_id                 = azurerm_subnet.ph-subnet.id
  network_security_group_id = azurerm_network_security_group.ph-net-sec-basedns[count.index].id
}

resource "azurerm_subnet_network_security_group_association" "ph-net-sec-assoc-baseclient" {
  count                     = var.dns_novpn + (length(var.client_cidrs) >= 1 ? 4 : 0) == 4 ? 1 : 0
  subnet_id                 = azurerm_subnet.ph-subnet.id
  network_security_group_id = azurerm_network_security_group.ph-net-sec-baseclient[count.index].id
}

resource "azurerm_network_security_group" "ph-net-sec-base" {
  count               = ((var.dns_novpn) + length(var.client_cidrs)) == 0 ? 1 : 0
  name                = "${var.ph_prefix}-net-sec-base"
  location            = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name = azurerm_resource_group.ph-resourcegroup.name
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-ssh"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-https"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-wireguard"
    priority                     = 102
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "51820"
    source_address_prefix        = "0.0.0.0/0"
    destination_address_prefixes = [var.az_subnet_cidr]
  }
}

resource "azurerm_network_security_group" "ph-net-sec-basednsclient" {
  count               = var.dns_novpn + (length(var.client_cidrs) >= 1 ? 1 : 0) == 2 ? 1 : 0
  name                = "${var.ph_prefix}-net-sec-base-dns-client"
  location            = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name = azurerm_resource_group.ph-resourcegroup.name
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-ssh"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-https"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-wireguard"
    priority                     = 102
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "51820"
    source_address_prefix        = "0.0.0.0/0"
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-dnstcp"
    priority                     = 200
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-dnsudp"
    priority                     = 201
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-clients-dnstcp"
    priority                     = 202
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefixes      = var.client_cidrs
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-clients-dnsudp"
    priority                     = 203
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefixes      = var.client_cidrs
    destination_address_prefixes = [var.az_subnet_cidr]
  }
}

resource "azurerm_network_security_group" "ph-net-sec-basedns" {
  count               = var.dns_novpn + (length(var.client_cidrs) == 0 ? 2 : 0) == 3 ? 1 : 0
  name                = "${var.ph_prefix}-net-sec-base-dns"
  location            = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name = azurerm_resource_group.ph-resourcegroup.name
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-ssh"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-https"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-wireguard"
    priority                     = 102
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "51820"
    source_address_prefix        = "0.0.0.0/0"
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-dnstcp"
    priority                     = 200
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-dnsudp"
    priority                     = 201
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
}

resource "azurerm_network_security_group" "ph-net-sec-baseclient" {
  count               = var.dns_novpn + (length(var.client_cidrs) >= 1 ? 4 : 0) == 4 ? 1 : 0
  name                = "${var.ph_prefix}-net-sec-base-client"
  location            = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name = azurerm_resource_group.ph-resourcegroup.name
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-ssh"
    priority                     = 100
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-https"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-wireguard"
    priority                     = 102
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "51820"
    source_address_prefix        = "0.0.0.0/0"
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-clients-dnstcp"
    priority                     = 202
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefixes      = var.client_cidrs
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.ph_prefix}-net-rule-clients-dnsudp"
    priority                     = 203
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Udp"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefixes      = var.client_cidrs
    destination_address_prefixes = [var.az_subnet_cidr]
  }
}
