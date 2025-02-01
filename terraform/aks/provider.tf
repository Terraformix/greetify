terraform {
  required_version = ">=1.8.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "azurerm" {
  
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id

  features {
  }
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
  username               = data.azurerm_kubernetes_cluster.this.kube_config.0.username
  password               = data.azurerm_kubernetes_cluster.this.kube_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)

  //config_path            = "~/.kube/config"
}

provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.this.kube_admin_config.0.host
  username               = azurerm_kubernetes_cluster.this.kube_admin_config.0.username
  password               = azurerm_kubernetes_cluster.this.kube_admin_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_admin_config.0.cluster_ca_certificate)

  //config_path            = "~/.kube/config"
}

provider "helm" {

  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)

    //config_path            = "~/.kube/config"
  }
}