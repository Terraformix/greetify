resource "azurerm_subnet" "firewall" {
  count = var.firewall_subnet_address_prefix != null ? 1 : 0
  name  = "AzureFirewallSubnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = var.firewall_subnet_address_prefix
}

