resource "azurerm_resource_group" "ph-resourcegroup" {
  name                    = "${var.ph_prefix}-resourcegroup"
  location                = var.az_region
}
