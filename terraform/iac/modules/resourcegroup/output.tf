output "resourcegroup_name" {
  description = "The name of the Resource Group created"
  value       = azurerm_resource_group.resourcegroup.name
} 
output "resourcegroup_id" {
  description = "The ID of the Resource Group created"
  value       = azurerm_resource_group.resourcegroup.id
  
}