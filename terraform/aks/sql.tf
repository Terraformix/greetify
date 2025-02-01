resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  
}

resource "azurerm_mssql_database" "db" {
  name           =  var.sql_db_name
  server_id      = azurerm_mssql_server.this.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"

  sku_name       = "Basic"
}

resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "allow-azure-service"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name             = "allow-my-ip"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = data.http.my_ip.body
  end_ip_address   = data.http.my_ip.body
}

resource "azurerm_mssql_virtual_network_rule" "aks" {
  count = length(module.aks_vnet.subnet_details[local.aks_subnet_name].service_endpoints) > 0 ? 1 : 0
  server_id = azurerm_mssql_server.this.id
  subnet_id = module.aks_vnet.subnet_details[local.aks_subnet_name].id
  name      = "aks-vnet-rule"
}

resource "azurerm_mssql_virtual_network_rule" "agent_vm" {
  count = length(module.agent_vnet.subnet_details[local.agent_vm_subnet_name].service_endpoints) > 0 ? 1 : 0
  server_id = azurerm_mssql_server.this.id
  subnet_id = module.agent_vnet.subnet_details[local.agent_vm_subnet_name].id
  name      = "agent-vm-vnet-rule"
}