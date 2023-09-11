resource "azurerm_private_link_service" "privatelink" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  load_balancer_frontend_ip_configuration_ids = var.load_balancer_frontend_ip_configuration_ids
  
  nat_ip_configuration {
    name                       = "primary"
    private_ip_address         = "10.21.3.37"
    private_ip_address_version = "IPv4"
    subnet_id                  = var.subnet_id
    primary                    = true
  }

  nat_ip_configuration {
    name                       = "secondary"
    private_ip_address         = "10.21.3.38"
    private_ip_address_version = "IPv4"
    subnet_id                  = var.subnet_id
    primary                    = false
  }
}