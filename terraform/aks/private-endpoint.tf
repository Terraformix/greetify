
# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_endpoint" {
  name                = "sql-private-endpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name 
  subnet_id           = module.aks_vnet.subnet_details[local.sql_pe_subnet_name].id

  private_service_connection {
    name                           = "sql-private-connection"
    private_connection_resource_id = azurerm_mssql_server.this.id
    is_manual_connection          = false
    subresource_names             = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "sql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_zone.id]
  }
}

# Private Endpoint for ACR
resource "azurerm_private_endpoint" "acr_endpoint" {
  name                = "acr-private-endpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.acr_vnet.subnet_details[local.acr_subnet_name].id

  private_service_connection {
    name                           = "acr-private-connection"
    private_connection_resource_id = azurerm_container_registry.this.id
    is_manual_connection          = false
    subresource_names             = ["registry"]
  }

  private_dns_zone_group {
    name                 = "acr-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_zone.id]
  }
}