variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the storage account"
  type        = string
}

variable "location" {
    description = "The location of the resource group in which to create the storage account."
    type        = string
    default     = "brazilsouth"
}

variable "name" {
  description = "(Required) Specifies the service bus name"
  type        = string
}