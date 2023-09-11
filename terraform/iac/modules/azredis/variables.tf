variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the storage account"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type = string 
  default = "brazilsouth"
}

variable "redis_name" {
    type = string
    description = "resource group name of the storage account"
}
