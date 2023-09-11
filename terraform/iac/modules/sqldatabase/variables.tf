variable "location" {
  type        = string
  description = "Location for all resources."
  default     = "brazilsouth"
}

variable "resource_group_name" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "rg-piloto"
}

variable "sql_server_name" {
  type        = string
  description = "The name of the SQL Server"
}

variable "sql_version" {
  type        = string
  description = "The name of the SQL Server"
  default = "12.0"
}

variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "SampleDB"
}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}