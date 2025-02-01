output "name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.this.name
}

output "id" {
  description = "The id of the virtual network"
  value       = azurerm_virtual_network.this.id
}

output "subnet_details" {
  description = "Comprehensive details for all subnets in the virtual network"
  value = merge(

    # Regular subnets  
    {
      for name, subnet in azurerm_subnet.subnets : name => {
        name                 = name
        id                   = subnet.id
        address_prefixes     = subnet.address_prefixes
        virtual_network_name = subnet.virtual_network_name
        resource_group_name  = subnet.resource_group_name

        service_endpoints           = subnet.service_endpoints
        service_endpoint_policy_ids = subnet.service_endpoint_policy_ids


        # Controls network access for private endpoints
        private_endpoint_network_policies = subnet.private_endpoint_network_policies
        private_link_service_network_policies = subnet.private_link_service_network_policies_enabled

        # Associated Network Security Group (if any)
        nsg_id = try(azurerm_subnet_network_security_group_association.this[name].network_security_group_id, null)
      }
    },

    # Bastion subnet if it exists
    var.bastion_subnet_address_prefix != null ? {
      "AzureBastionSubnet" = {
        name                                  = azurerm_subnet.bastion[0].name
        id                                    = azurerm_subnet.bastion[0].id
        address_prefixes                      = azurerm_subnet.bastion[0].address_prefixes
        virtual_network_name                  = azurerm_subnet.bastion[0].virtual_network_name
        resource_group_name                   = azurerm_subnet.bastion[0].resource_group_name
        service_endpoints                     = []
        service_endpoint_policy_ids           = []
        private_endpoint_network_policies     = null
        private_link_service_network_policies = null
        nsg_id                                = null
      }
    } : {}
    ,

    # Gateway subnet if it exists
    var.gateway_subnet_address_prefix != null ? {
      "GatewaySubnet" = {
        name                                  = azurerm_subnet.gateway[0].name
        id                                    = azurerm_subnet.gateway[0].id
        address_prefixes                      = azurerm_subnet.gateway[0].address_prefixes
        virtual_network_name                  = azurerm_subnet.gateway[0].virtual_network_name
        resource_group_name                   = azurerm_subnet.gateway[0].resource_group_name
        service_endpoints                     = []
        service_endpoint_policy_ids           = []
        private_endpoint_network_policies     = null
        private_link_service_network_policies = null
        nsg_id                                = null
      }
    } : {}

    ,

    # Firewall subnet if it exists        
    var.gateway_subnet_address_prefix != null ? {
      "AzureFirewallSubnet" = {
        name                                  = azurerm_subnet.firewall[0].name
        id                                    = azurerm_subnet.firewall[0].id
        address_prefixes                      = azurerm_subnet.firewall[0].address_prefixes
        virtual_network_name                  = azurerm_subnet.firewall[0].virtual_network_name
        resource_group_name                   = azurerm_subnet.firewall[0].resource_group_name
        service_endpoints                     = []
        service_endpoint_policy_ids           = []
        private_endpoint_network_policies     = null
        private_link_service_network_policies = null
        nsg_id                                = null
      }
    } : {}
  )
}

output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = [for n in azurerm_network_security_group.this : n.id]
}
