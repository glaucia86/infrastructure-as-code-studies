resource "azurerm_key_vault" "keyvault" {
  name                       = var.vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku_name                   = var.sku_name
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = 7
}
