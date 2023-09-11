variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the storage account"
  type        = string
}

variable "location" {
    description = "The location of the resource group in which to create the storage account."
    type        = string
    default     = "brazilsouth"
    validation {
      condition     = contains(["brazilsouth", "brazilsoutheast"], var.location)
      error_message = "The location must be one of the following: brazilsouth, brazilsoutheast."
    }
}

variable "vault_name" {
  type        = string
  description = "The name of the key vault to be created. The value will be randomly generated if blank."
  default     = ""
}

variable "key_name" {
  type        = string
  description = "The name of the key to be created. The value will be randomly generated if blank."
  default     = ""
}

variable "sku_name" {
  type        = string
  description = "The SKU of the vault to be created."
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The sku_name must be one of the following: standard, premium."
  }
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID used for authenticating requests to the key vault."
  default     = ""
}
