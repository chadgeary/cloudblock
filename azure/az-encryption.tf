data "azurerm_client_config" "ph-client-conf" {
}

resource "azurerm_key_vault" "ph-vault" {
  name                    = "${var.ph_prefix}-vault"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_enabled     = true
  purge_protection_enabled = true
  sku_name                = "standard"
}

resource "azurerm_key_vault_key" "ph-disk-key" {
  name                    = "${var.ph_prefix}-disk-key"
  key_vault_id            = azurerm_key_vault.ph-vault.id
  key_type                = "RSA"
  key_size                = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  depends_on              = [azurerm_key_vault_access_policy.ph-vault-access-admin]
}

resource "azurerm_disk_encryption_set" "ph-disk-encrypt" {
  name                    = "${var.ph_prefix}-disk-encrypt"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  key_vault_key_id        = azurerm_key_vault_key.ph-disk-key.id
  identity {
    type                    = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "ph-vault-access-disk" {
  key_vault_id            = azurerm_key_vault.ph-vault.id
  tenant_id               = azurerm_disk_encryption_set.ph-disk-encrypt.identity.0.tenant_id
  object_id               = azurerm_disk_encryption_set.ph-disk-encrypt.identity.0.principal_id
  key_permissions = [
    "get",
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
    "unwrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "ph-vault-access-admin" {
  key_vault_id            = azurerm_key_vault.ph-vault.id
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  object_id               = data.azurerm_client_config.ph-client-conf.object_id
  key_permissions = [
    "create",
    "delete",
    "get",
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]
}
