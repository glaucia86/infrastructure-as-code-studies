
resource "azurerm_servicebus_namespace" "servicebus" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = {
    source = "piloto"
  }
}