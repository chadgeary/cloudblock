resource "azurerm_user_assigned_identity" "ph-instance-id" {
  name                    = "${var.ph_prefix}-instance-id-${random_string.ph-random.result}"
  location                = azurerm_resource_group.ph-resourcegroup.location
  resource_group_name     = azurerm_resource_group.ph-resourcegroup.name
}

resource "random_uuid" "ph-instance-role-uuid" {
}

resource "azurerm_role_definition" "ph-instance-role" {
  name                    = "${var.ph_prefix}-instance-role-${random_string.ph-random.result}"
  role_definition_id      = random_uuid.ph-instance-role-uuid.result
  scope                   = data.azurerm_subscription.ph-subscription.id
  assignable_scopes       = [data.azurerm_subscription.ph-subscription.id]
  permissions {
    actions                 = [
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/listKeys/action",
      "Microsoft.Storage/storageAccounts/read"
    ]
    data_actions             = [
      "Microsoft.KeyVault/vaults/secrets/getSecret/action"
    ]
  }
}

resource "azurerm_role_assignment" "ph-instance-role-assignment" {
  scope                   = data.azurerm_subscription.ph-subscription.id
  role_definition_id      = azurerm_role_definition.ph-instance-role.role_definition_resource_id
  principal_id            = azurerm_user_assigned_identity.ph-instance-id.principal_id
}
