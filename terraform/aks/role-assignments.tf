# Allow AKS Identity to read secrets from Key Vault
resource "azurerm_role_assignment" "aks_kv_reader" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

# Assign Terraform Service Principal/Current logged in user to be able to Manage secrets in Azure (Create secrets in IaC)
resource "azurerm_role_assignment" "terraform_sp_kv_admin" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_service_principal.terraform_sp.object_id

  depends_on = [ azurerm_key_vault.this ]
}

# Allow the AKS Identity a role to pull images from the ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity.0.object_id
}

# Allow the AKS Identity a role to manage DNS Zone resources on the AKS Private DNS Zone
resource "azurerm_role_assignment" "aks_dns_contributor" {
  scope                = azurerm_private_dns_zone.aks_zone.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_access.principal_id

}

# Allow the AKS Identity a role to manage Virtual Networks on the AKS VNet
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = module.aks_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_access.principal_id
  
}

# Allow the Agent VM Managed Identity (Self-hosted github actions runner) a role to allow basic resource interaction capabilities on the Subscription
resource "azurerm_role_assignment" "agent_vm_subscription_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_virtual_machine.agent.identity[0].principal_id
}

# Allow the Agent VM Managed Identity (Self-hosted github actions runner) to push images to the ACR
resource "azurerm_role_assignment" "agent_vm_acr_push" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_linux_virtual_machine.agent.identity[0].principal_id
}

# Allow the Agent VM Managed Identity (Self-hosted github actions runner) to access the AKS Cluster
resource "azurerm_role_assignment" "agent_vm_aks_cluster_user" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azurerm_linux_virtual_machine.agent.identity[0].principal_id
}


# # Allow the Agent VM Managed Identity (Self-hosted github actions runner) to read secrets from Key Vault when running workflows
resource "azurerm_role_assignment" "agent_vm_kv_reader" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Reader"
  principal_id         =   azurerm_linux_virtual_machine.agent.identity[0].principal_id
}

# App Gateway needs to manage the network on the AKS cluster to handle ingress
# resource "azurerm_role_assignment" "appgw_contributor" {
#   scope                = azurerm_application_gateway.this.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_kubernetes_cluster.this.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
# }

# resource "azurerm_role_assignment" "appgw_network_contributor" {
#   scope                = module.appgw_vnet.subnet_details[var.appgw_subnet_name].id
#   role_definition_name = "Network Contributor"
#   principal_id         = azurerm_kubernetes_cluster.this.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
# }