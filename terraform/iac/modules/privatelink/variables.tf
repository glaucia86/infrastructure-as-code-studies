variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the storage account"
  type        = string
}

variable "name" {
    description = "The name of the private link."
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

variable "load_balancer_frontend_ip_configuration_ids" {
    description = "The azurerm_lb_id of the private link."
    type        = list
}