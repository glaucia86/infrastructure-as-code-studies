resource "azurerm_application_gateway" "appgateway" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "vnet-piloto-feport"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "vnet-piloto-feport"
  }

  backend_address_pool {
    name = "vnet-piloto-backpool"
  }

  backend_http_settings {
    name                  = "vnet-piloto-hths"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "vnet-piloto-httplstn"
    frontend_ip_configuration_name = "vnet-piloto-feip"
    frontend_port_name             = "vnet-piloto-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "vnet-piloto-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "vnet-piloto-httplstn"
  }
}