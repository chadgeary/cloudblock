resource "azurerm_network_interface" "ph-net-interface" {
  name                    = "${var.ph_prefix}-nic"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  ip_configuration {
    name                    = "${var.ph_prefix}-ipconf"
    subnet_id               = element(azurerm_virtual_network.ph-network.subnet[*].id,0)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id    = azurerm_public_ip.ph-public-ip.id
    primary                 = true
  }
}

resource "azurerm_linux_virtual_machine" "ph-instance" {
  name                    = "${var.ph_prefix}-instance"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  size                 = var.az_vm_size
  admin_username          = var.ssh_user
  network_interface_ids   = [azurerm_network_interface.ph-net-interface.id]
  admin_ssh_key {
    username                = var.ssh_user
    public_key              = var.ssh_key
  }
  os_disk {
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    disk_encryption_set_id  = azurerm_disk_encryption_set.ph-disk-encrypt.id
    disk_size_gb            = var.az_disk_gb
  }
  source_image_reference {
    publisher               = "Canonical"
    offer                   = "UbuntuServer"
    sku                     = "18_04-lts-gen2"
    version                 = var.az_image_version
  }
  depends_on                = [azurerm_key_vault_access_policy.ph-vault-access-disk]
}
