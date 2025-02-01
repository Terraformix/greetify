# Private DNS Zone for SQL Server
resource "azurerm_private_dns_zone" "sql_zone" {
  name                = local.sql_private_dns_endpoint
  resource_group_name = azurerm_resource_group.this.name
}

# Allow AKS VNet to resolve DNS queries using the records in the SQL Private DNS zone.
resource "azurerm_private_dns_zone_virtual_network_link" "sql_vnet_link" {
  name                  = "sql-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_zone.name
  virtual_network_id    = module.aks_vnet.id
}

# Allow Agent VNet to resolve DNS queries using the records in the SQL Private DNS zone.
resource "azurerm_private_dns_zone_virtual_network_link" "agent_sql_vnet_link" {
  name                  = "agent-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_zone.name
  virtual_network_id    = module.agent_vnet.id
}

# Private DNS Zone for ACR
resource "azurerm_private_dns_zone" "acr_zone" {
  name                = local.acr_private_dns_endpoint
  resource_group_name = azurerm_resource_group.this.name
}

# Link ACR VNet to the ACR DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "acr_vnet_link" {
  name                  = "acr-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_zone.name
  virtual_network_id    = module.acr_vnet.id
}

# Link AKS VNet to the ACR DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "aks_acr_vnet_link" {
  name                  = "aks-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_zone.name
  virtual_network_id    = module.aks_vnet.id
}

# Link Agent VNet to the ACR DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "agent_vnet_link" {
  name                  = "agent-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_zone.name
  virtual_network_id    = module.agent_vnet.id
}


# Private DNS Zone for AKS
resource "azurerm_private_dns_zone" "aks_zone" {
  name                = local.aks_private_dns_endpoint
  resource_group_name = azurerm_resource_group.this.name
}

# Link AKS VNet to the AKS DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "aks_vnet_link" {
  name                  = "aks-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.aks_zone.name
  virtual_network_id    = module.aks_vnet.id
}

# Link ACR VNet to the AKS DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "aks_acr_link" {
  name                  = "acr-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.aks_zone.name
  virtual_network_id    = module.acr_vnet.id
}

# Link Agent VNet to the AKS DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "aks_agent_link" {
  name                  = "agent-vnet-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.aks_zone.name
  virtual_network_id    =  module.agent_vnet.id
}