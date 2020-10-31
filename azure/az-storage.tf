resource "azurerm_storage_account" "ph-storage-account" {
  name                    = "${var.ph_prefix}store${random_string.ph-random.result}"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
  account_kind            = "StorageV2"
  account_tier            = "Standard"
  access_tier             = "Hot"
  min_tls_version         = "TLS1_2"
  account_replication_type = "LRS"
  allow_blob_public_access = "false"
  identity {
    type                    = "SystemAssigned"
  }
}

resource "azurerm_storage_account_customer_managed_key" "ph-storage-cmk" {
  storage_account_id      = azurerm_storage_account.ph-storage-account.id
  key_vault_id            = azurerm_key_vault.ph-vault-storage.id
  key_name                = azurerm_key_vault_key.ph-storage-key.name
}

resource "azurerm_storage_container" "ph-storage-container" {
  name                    = "${var.ph_prefix}-storage-container"
  storage_account_name    = azurerm_storage_account.ph-storage-account.name
  container_access_type   = "private"
}
