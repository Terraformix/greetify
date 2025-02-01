resource "azurerm_subnet" "gateway" {
  count = var.gateway_subnet_address_prefix != null ? 1 : 0
  name  = "GatewaySubnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = var.gateway_subnet_address_prefix
}