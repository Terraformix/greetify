module "aks_vnet" {
  source              = "../modules/virtual-network"
  resource_group_name = azurerm_resource_group.this.name
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location

  subnets = {
    "${local.aks_subnet_name}" = {
      subnet_address_prefix = ["10.0.0.0/24"]
      # By using the "Microsoft.Sql" service endpoint, we ensure that all communication with SQL Server remains within the private Azure network for better security and performance.
      service_endpoints = ["Microsoft.Sql"]
    }

    # Dedicated to hosting the private endpoint for the SQL Server instance
    "${local.sql_pe_subnet_name}" = {
      subnet_address_prefix = ["10.0.1.0/24"]
      private_link_service_network_policies_enabled = true
    }
  }
}

module "acr_vnet" {
  source              = "../modules/virtual-network"
  resource_group_name = azurerm_resource_group.this.name
  name                = "acr-vnet"
  address_space       = ["11.0.0.0/16"]
  location            = azurerm_resource_group.this.location

  subnets = {
    "${local.acr_subnet_name}" = {
      subnet_address_prefix = ["11.0.0.0/24"]
    }
  }
}

# Peering between AKS and ACR VNets
resource "azurerm_virtual_network_peering" "aks_acr" {
  name                      = "aks-acr"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name      = module.aks_vnet.name
  remote_virtual_network_id = module.acr_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

# Reciprocal peering from ACR to AKS
resource "azurerm_virtual_network_peering" "acr_aks" {
  name                      = "acr-aks"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name      = module.acr_vnet.name
  remote_virtual_network_id = module.aks_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

module "agent_vnet" {
  source              = "../modules/virtual-network"
  resource_group_name = azurerm_resource_group.this.name
  name                = "agent-vnet"
  address_space       = ["12.0.0.0/16"]
  location            = azurerm_resource_group.this.location

  # Uncomment to use a Bastion for accessing the private agent VM
  # bastion_subnet_address_prefix = ["12.0.0.0/26"]

  subnets = {
    "${local.agent_vm_subnet_name}" = {
      subnet_address_prefix = ["12.0.1.0/24"]

      # By using the "Microsoft.Sql" service endpoint, we ensure that all communication with SQL Server remains within the private Azure network for better security and performance.
      service_endpoints = ["Microsoft.Sql"]

      # [name, priority, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
      nsg_inbound_rules = [
        ["allow-ssh", 100, "Allow", "Tcp", "22", "*", "*"],
        ["allow-rdp", 3389, "Allow", "Tcp", "22", "*", "*"]
      ]
    }
  }
}

# Peering between ACR and Agent VM Virtual Networks
resource "azurerm_virtual_network_peering" "acr_agent" {
  name                      = "acr-agent"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name      = module.acr_vnet.name
  remote_virtual_network_id = module.agent_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

# Reciprocal peering from Agent VM to ACR
resource "azurerm_virtual_network_peering" "agent_acr" {
  name                      = "agent-acr"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name      = module.agent_vnet.name
  remote_virtual_network_id = module.acr_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

# Peering between AKS and Agent VM Virtual Networks
resource "azurerm_virtual_network_peering" "aks_agent" {
  name                      = "agent-aks"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name      = module.aks_vnet.name
  remote_virtual_network_id = module.agent_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

# Reciprocal peering from Agent VM to AKS
resource "azurerm_virtual_network_peering" "agent_aks" {
  name                      = "aks-agent"
  resource_group_name = azurerm_resource_group.this.name
  virtual_network_name      = module.agent_vnet.name
  remote_virtual_network_id = module.aks_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

module "appgw_vnet" {
  source              = "../modules/virtual-network"
  resource_group_name = azurerm_resource_group.this.name
  name                = "appgw-vnet"
  address_space       = ["13.0.0.0/16"]
  location            = azurerm_resource_group.this.location

  subnets = {
    "${local.appgw_subnet_name}" = {
      subnet_address_prefix = ["13.0.0.0/24"]
    }
  }

}