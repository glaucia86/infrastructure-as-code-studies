variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the storage account"
  type        = string
}

variable "storage_account_name" {
    description = "The name of the storage account."
    type        = string
}

variable "location" {
    description = "The location of the resource group in which to create the storage account."
    type        = string
    default     = "brazilsouth"
}

variable "account_tier" {
    description = "Defines the Tier to use for this storage account."
    type        = string
    default = "Standard"
}

variable "account_replication_type" {
    description = "Defines the type of replication to use for this storage account."
    type        = string
    default = "LRS"
}
variable "access_tier" {
    description = "The access tier for BlobStorage and StorageV2 accounts."
    type        = string
    default = "Hot"
}

variable "tags" {
    description = "A mapping of tags to assign to the resource."
    type        = map
    default = {
        environment = "dev"
    }	
}