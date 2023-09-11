
resource "azurerm_mssql_server" "sqldatabase" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  version                      = var.sql_version
}

resource "azurerm_mssql_database" "sqldb" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.sqldatabase.id
}