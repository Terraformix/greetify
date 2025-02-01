data "azurerm_kubernetes_cluster" "this" {
  name                = azurerm_kubernetes_cluster.this.name
  resource_group_name = azurerm_resource_group.this.name
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}


data "http" "my_ip" {
  url = "https://api.ipify.org"
}

# Service principal for Github Actions to run workflows
data "azuread_service_principal" "gh_actions_sp" {
  display_name = var.gh_actions_service_principal_name
}

# Service principal for Terraform to provision infra
data "azuread_service_principal" "terraform_sp" {
  display_name = var.tf_service_principal_name
}

# Get latest Kubernetes version
data "azurerm_kubernetes_service_versions" "current" {
  location       = azurerm_resource_group.this.location
  include_preview = false
}