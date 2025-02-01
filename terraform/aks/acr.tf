resource "azurerm_container_registry" "this" {
  name                          = local.acr_name
  resource_group_name          = azurerm_resource_group.this.name
  location                     = azurerm_resource_group.this.location
  sku                          = "Premium"  # Required for private registry
  admin_enabled               = false
  public_network_access_enabled = false
  
  depends_on = [ module.acr_vnet ]
}
