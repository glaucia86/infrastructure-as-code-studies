resource "azurerm_api_management" "apim_service" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "Rogério Rodrigues"
  publisher_email     = "rrodrigues@microsoft.com"
  sku_name            = "Developer_1"
  tags = {
    Environment = "dev"
  }
  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />  
      <on-error />
    </policies>
XML
  }
}
//Definir regras para publicacao de API do LCE
/*resource "azurerm_api_management_api" "api" {
  name                = "conference-api"
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  revision            = "1"
  display_name        = "conference-api"
  path                = "example"
  protocols           = ["https", "http"]
  description         = "An example API"
  import {
    content_format = "swagger-link-json"
    content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  }
}*/