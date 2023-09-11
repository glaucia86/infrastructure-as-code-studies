variable "sigla_caixa" {
  description = "Specifies the system"            
  default     = "lce"
  type        = string
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "brazilsouth"
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  default     = "rg-piloto"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default = {
    createdWith = "piloto"
  }
}