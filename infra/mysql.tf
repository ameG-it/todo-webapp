resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "${var.project_name}-${var.environment}-${random_string.name.result}-mysql"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  administrator_login    = var.mysql_username
  administrator_password = var.mysql_password
  backup_retention_days  = 7
  sku_name               = "GP_Standard_D2ds_v4"
  version                = "8.0.21"


  lifecycle {
    ignore_changes = [
      administrator_password,
      administrator_login,
      zone
    ]
  }

}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysqlrule" {
  name                = "AllowAllWindowsAzureService"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}


resource "azurerm_mysql_flexible_database" "mysqldb" {
  name                = var.mysql_database
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}