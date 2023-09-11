variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the storage account"
  type        = string
}

variable "name" {
    description = "The name of the app gateway."
    type        = string
}

variable "location" {
    description = "The location of the resource group in which to create the storage account."
    type        = string
    default     = "brazilsouth"
}

variable "subnet_id" {
    description = "The azurerm_subnet_id of the private link."
    type        = string
}

variable "backend_address_pool_name" {
    default = "myBackendPool"
}

variable "frontend_port_name" {
    default = "myFrontendPort"
}

variable "frontend_ip_configuration_name" {
    default = "myAGIPConfig"
}

variable "http_setting_name" {
    default = "myHTTPsetting"
}

variable "listener_name" {
    default = "myListener"
}

variable "request_routing_rule_name" {
    default = "myRoutingRule"
}