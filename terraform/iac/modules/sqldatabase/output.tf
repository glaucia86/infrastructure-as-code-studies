output "resource_group_name" {
  value = var.resource_group_name
}
output "sql_server_name" {
  value = var.sql_server_name
}
output "admin_password" {
  sensitive = true
  value     = var.admin_password
}