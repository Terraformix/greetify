module "common_settings" {
  source = "../modules/common"
}

resource "random_string" "this" {
  length  = 3
  upper   = false
  special = false
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.aks_cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

  private_cluster_enabled = true
  private_dns_zone_id = azurerm_private_dns_zone.aks_zone.id
  sku_tier   = var.aks_sku_tier
  dns_prefix = "${local.aks_cluster_name}-dns"  

  default_node_pool {
    name           = "default"
    vm_size        = "Standard_B2s"
    enable_auto_scaling = false
    node_count     = 2
    max_pods = 50
    vnet_subnet_id =  module.aks_vnet.subnet_details[local.aks_subnet_name].id
    zones = [ "1", "2" ]
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_access.id]
  }
  
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  # ingress_application_gateway {
  #   gateway_id = azurerm_application_gateway.this.id
  # }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy = "calico" 
    dns_service_ip    = "10.0.64.10"
    service_cidr      = "10.0.64.0/19"
  }

  depends_on = [ 
    azurerm_role_assignment.aks_network_contributor,
    azurerm_role_assignment.aks_dns_contributor
  ]

  tags = merge(var.common_tags, {})
}


resource "azurerm_monitor_diagnostic_setting" "this" {
  name               = "aks-container-insights"
  target_resource_id = azurerm_kubernetes_cluster.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id


  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "kube-audit"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

