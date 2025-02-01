resource "azurerm_subnet" "bastion" {
  count = var.bastion_subnet_address_prefix != null ? 1 : 0
  name  = "AzureBastionSubnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = var.bastion_subnet_address_prefix
}