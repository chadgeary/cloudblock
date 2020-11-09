resource "azurerm_network_interface" "ph-net-interface" {
  name                    = "${var.ph_prefix}-nic"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  ip_configuration {
    name                    = "${var.ph_prefix}-ipconf"
    subnet_id               = azurerm_subnet.ph-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id    = azurerm_public_ip.ph-public-ip.id
    primary                 = true
  }
}

data "template_file" "ph-custom-data" {
  template                = file("az-custom_data.tpl")
  vars                    = {
    project_url = var.project_url
    ph_prefix = var.ph_prefix
    ph_suffix = random_string.ph-random.result
    docker_network = var.docker_network
    docker_gw = var.docker_gw
    docker_doh = var.docker_doh
    docker_pihole = var.docker_pihole
    docker_wireguard = var.docker_wireguard
    docker_webproxy = var.docker_webproxy
    wireguard_network = var.wireguard_network
    doh_provider = var.doh_provider
    dns_novpn = var.dns_novpn
    wireguard_peers = var.wireguard_peers
    vpn_traffic = var.vpn_traffic
  }
}

resource "azurerm_linux_virtual_machine" "ph-instance" {
  name                    = "${var.ph_prefix}-instance"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  size                    = var.az_vm_size
  admin_username          = var.ssh_user
  network_interface_ids   = [azurerm_network_interface.ph-net-interface.id]
  admin_ssh_key {
    username                = var.ssh_user
    public_key              = var.ssh_key
  }
  os_disk {
    caching                 = "ReadWrite"
    storage_account_type    = "Premium_LRS"
    disk_encryption_set_id  = azurerm_disk_encryption_set.ph-disk-encrypt.id
    disk_size_gb            = var.az_disk_gb
  }
  source_image_reference {
    publisher               = "Canonical"
    offer                   = "UbuntuServer"
    sku                     = "18_04-lts-gen2"
    version                 = var.az_image_version
  }
  identity {
    type                    = "UserAssigned"
    identity_ids            = [azurerm_user_assigned_identity.ph-instance-id.id]
  }
  custom_data               = base64encode(data.template_file.ph-custom-data.rendered)
  depends_on                = [azurerm_key_vault_access_policy.ph-vault-disk-access-disk,azurerm_role_assignment.ph-instance-role-assignment]
}
