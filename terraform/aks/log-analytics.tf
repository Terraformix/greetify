resource "azurerm_log_analytics_workspace" "this" {
  name                = var.aks_law_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = merge(var.common_tags, {})
}