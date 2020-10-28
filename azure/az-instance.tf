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
    wireguard_network = var.wireguard_network
    doh_provider = var.doh_provider
    dns_novpn = var.dns_novpn
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
    type                    = "SystemAssigned"
  }
  custom_data               = base64encode(data.template_file.ph-custom-data.rendered)
  depends_on                = [azurerm_key_vault_access_policy.ph-vault-disk-access-disk]
}

resource "azurerm_role_definition" "ph-instance-role" {
  name                    = "${var.ph_prefix}-instance-role"
  scope                   = data.azurerm_subscription.ph-subscription.id
  assignable_scopes       = [data.azurerm_subscription.ph-subscription.id]
  permissions {
    actions                 = [
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read"
    ]
    data_actions             = [
      "Microsoft.KeyVault/vaults/secrets/getSecret/action"
    ]
  }
}

resource "azurerm_role_assignment" "ph-instance-role-assignment" {
  scope                   = data.azurerm_subscription.ph-subscription.id
  role_definition_id      = azurerm_role_definition.ph-instance-role.role_definition_resource_id
  principal_id            = azurerm_linux_virtual_machine.ph-instance.identity[0].principal_id
}
