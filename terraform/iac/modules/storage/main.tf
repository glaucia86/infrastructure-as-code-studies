resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier = "Hot"
  enable_https_traffic_only = true
   
  lifecycle {
    prevent_destroy = true
  }

  network_rules {
    default_action = "Deny"
    ip_rules       = ["23.45.1.0/30"]
  }

}