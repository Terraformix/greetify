locals {
  aks_cluster_name = "${var.aks_name}${random_string.this.result}"
  acr_name = "${var.acr_name}${random_string.this.result}"
  key_vault_name = "${var.key_vault_name}${random_string.this.result}"
  rg_name = "${var.resource_group_name}${random_string.this.result}"
  sql_server_name = "${var.sql_server_name}${random_string.this.result}"

  agent_vm_subnet_name = "agent-vm"
  aks_subnet_name = "aks"
  acr_subnet_name = "acr"
  sql_pe_subnet_name = "sql_pe"
  appgw_subnet_name = "appgw"

  sql_private_dns_endpoint = "privatelink.database.windows.net"
  acr_private_dns_endpoint = "privatelink.azurecr.io"
  aks_private_dns_endpoint = "privatelink.${lower(azurerm_resource_group.this.location)}.azmk8s.io"

}
