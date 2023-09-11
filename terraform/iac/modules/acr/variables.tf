variable "name" {
  type = string
  description = "name of the resource"
}

variable "resource_group_name" {
  type = string
  description = "name of the resource"
}

variable "location" {
  type = string
  description = "location"
  default = "brazilsouth"
}

variable "sku_name" {
  type = string
  description = "sku name"
  default = "Basic"
}