resource "azurerm_service_plan" "asp" {
  name                = "${var.project_name}-${var.environment}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.project_name}-${var.environment}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      docker_image_name        = var.image_container
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    }
  }


  app_settings = {
    "MYSQL_HOST"     = azurerm_mysql_flexible_server.mysql.fqdn
    "MYSQL_PORT"     = "3306"
    "MYSQL_USER"     = var.mysql_username
    "MYSQL_PASSWORD" = var.mysql_password
    "MYSQL_DATABASE" = var.mysql_database
    "MYSQL_SSL"      = "true"
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack,
    ]
  }
}