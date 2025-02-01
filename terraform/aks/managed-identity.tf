resource "azurerm_user_assigned_identity" "aks_access" {
  name                = "aks-access"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}