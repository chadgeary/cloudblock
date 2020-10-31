resource "azurerm_key_vault" "ph-vault-disk" {
  name                    = "${var.ph_prefix}-disk-${random_string.ph-random.result}"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  sku_name                = "standard"
  enabled_for_disk_encryption = true
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
}

resource "azurerm_key_vault" "ph-vault-storage" {
  name                    = "${var.ph_prefix}-storage-${random_string.ph-random.result}"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  sku_name                = "standard"
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
}

resource "azurerm_key_vault" "ph-vault-secret" {
  name                    = "${var.ph_prefix}-secret-${random_string.ph-random.result}"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  sku_name                = "standard"
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
}

resource "azurerm_key_vault_access_policy" "ph-vault-disk-access-admin" {
  key_vault_id            = azurerm_key_vault.ph-vault-disk.id
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  object_id               = data.azurerm_client_config.ph-client-conf.object_id
  key_permissions         = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
}

resource "azurerm_key_vault_access_policy" "ph-vault-storage-access-admin" {
  key_vault_id            = azurerm_key_vault.ph-vault-storage.id
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  object_id               = data.azurerm_client_config.ph-client-conf.object_id
  key_permissions         = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
}

resource "azurerm_key_vault_access_policy" "ph-vault-secret-access-admin" {
  key_vault_id            = azurerm_key_vault.ph-vault-secret.id
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  object_id               = data.azurerm_client_config.ph-client-conf.object_id
  secret_permissions      = ["set","get","delete","list","purge","recover","restore"]
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

resource "azurerm_key_vault_access_policy" "ph-vault-disk-access-disk" {
  key_vault_id            = azurerm_key_vault.ph-vault-disk.id
  tenant_id               = azurerm_disk_encryption_set.ph-disk-encrypt.identity.0.tenant_id
  object_id               = azurerm_disk_encryption_set.ph-disk-encrypt.identity.0.principal_id
  key_permissions         = ["get","decrypt","encrypt","sign","unwrapKey","verify","wrapKey","unwrapKey"]
}

resource "azurerm_key_vault_access_policy" "ph-vault-storage-access-storage" {
  key_vault_id            = azurerm_key_vault.ph-vault-storage.id
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  object_id               = azurerm_storage_account.ph-storage-account.identity.0.principal_id
  key_permissions         = ["get", "create", "list", "restore", "recover", "unwrapkey", "wrapkey", "encrypt", "decrypt", "sign", "verify"]
}

resource "azurerm_key_vault_access_policy" "ph-vault-secret-access-instance" {
  key_vault_id            = azurerm_key_vault.ph-vault-secret.id
  tenant_id               = data.azurerm_client_config.ph-client-conf.tenant_id
  object_id               = azurerm_user_assigned_identity.ph-instance-id.principal_id
  secret_permissions      = ["get","list"]
}

resource "time_sleep" "wait_for_vaults" {
  create_duration         = "30s"
  depends_on              = [azurerm_key_vault_access_policy.ph-vault-disk-access-admin,azurerm_key_vault_access_policy.ph-vault-storage-access-admin,azurerm_key_vault_access_policy.ph-vault-storage-access-storage,azurerm_key_vault_access_policy.ph-vault-secret-access-admin]
}

resource "azurerm_key_vault_key" "ph-disk-key" {
  name                    = "${var.ph_prefix}-disk-key"
  key_vault_id            = azurerm_key_vault.ph-vault-disk.id
  key_type                = "RSA"
  key_size                = 2048
  key_opts                = ["decrypt","encrypt","sign","unwrapKey","verify","wrapKey"]
  depends_on              = [time_sleep.wait_for_vaults]
}

resource "azurerm_key_vault_key" "ph-storage-key" {
  name                    = "${var.ph_prefix}-storage-key"
  key_vault_id            = azurerm_key_vault.ph-vault-storage.id
  key_type                = "RSA"
  key_size                = 2048
  key_opts                = ["decrypt","encrypt","sign","unwrapKey","verify","wrapKey"]
  depends_on              = [time_sleep.wait_for_vaults]
}

resource "azurerm_key_vault_secret" "ph-secret" {
  name                    = "${var.ph_prefix}-secret"
  value                   = var.ph_password
  key_vault_id            = azurerm_key_vault.ph-vault-secret.id
  depends_on              = [time_sleep.wait_for_vaults]
}
