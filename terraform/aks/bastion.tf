# Uncomment this code to use a Bastion instead of exposing the Agent VM publicly

# Bastion Public IP
# resource "azurerm_public_ip" "bastion" {
#   name                = "bastion-pip"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
#   allocation_method   = "Static"
#   sku                = "Standard"
# }

# Azure Bastion Host
# resource "azurerm_bastion_host" "this" {
#   name                = "bastion"
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id           = module.agent_vnet.subnet_details["AzureBastionSubnet"].id
#     public_ip_address_id = azurerm_public_ip.bastion.id
#   }

#   depends_on = [ module.agent_vnet ]
# }