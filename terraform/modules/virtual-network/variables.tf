variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from Azure CLI, run 'az account list-locations -o table'"
  type        = string
}

variable "name" {
  description = "Name of your Azure Virtual Network"
  type        = string
  default     = "vnet"
}

variable "address_space" {
  description = "The address space to be used for the Azure virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "firewall_subnet_address_prefix" {
  description = "The address prefix to use for the Firewall subnet"
  type        = list(string)
  default     = null
}

variable "firewall_service_endpoints" {
  description = "Service endpoints to add to the Firewall subnet"
  type        = list(string)
  default = [
    "Microsoft.AzureActiveDirectory",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
}


variable "bastion_subnet_address_prefix" {
  description = "The address prefix to use for the Firewall subnet"
  type        = list(string)
  default     = null
}

variable "gateway_subnet_address_prefix" {
  description = "The address prefix to use for the Firewall subnet"
  type        = list(string)
  default     = null
}

variable "gateway_service_endpoints" {
  description = "Service endpoints to add to the Gateway subnet"
  type        = list(string)
  default     = []
}


variable "subnets" {
  type = map(object({
    subnet_address_prefix = list(string)
    service_endpoints    = optional(list(string), [])
    service_endpoint_policy_ids = optional(list(string))
    private_endpoint_network_policies = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))

    nsg_inbound_rules = optional(list(list(string)))
    nsg_outbound_rules = optional(list(list(string)))
  }))
  description = "Map of subnet configurations"
}


variable "common_tags" {
  description = "Common tags to be applied across multiple resources"
  type = map(string)
  default = {
    "Environment" = "Development",
    "Department" = "IT"
  }
}

