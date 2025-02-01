# resource "azurerm_public_ip" "appgw_fe_public_ip" {
#   name                = var.appgw_fe_public_ip_name
#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_application_gateway" "this" {
#   name                = var.appgw_name
#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location

#   sku {
#     name     = "Standard_v2"
#     tier     = "Standard_v2"
#     capacity = 1
#   }

#   gateway_ip_configuration {
#     name      = var.appgw_ip_config_name
#     subnet_id = module.appgw_vnet.subnet_details[var.appgw_subnet_name].id
#   }

#   frontend_port {
#     name = var.appgw_fe_port_name
#     port = 80
#   }

#   frontend_port {
#      name = "httpsPort"
#      port = 443
#    }

#   frontend_ip_configuration {
#     name                 = var.appgw_fe_ip_config_name
#     public_ip_address_id = azurerm_public_ip.appgw_fe_public_ip.id
#   }

#   backend_address_pool {
#     name = var.appgw_be_pool_name
#   }

#   backend_http_settings {
#     name                  = var.appgw_be_http_setting_name
#     cookie_based_affinity = "Disabled"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 1
#   }
  

#   http_listener {
#     name                           = var.appgw_http_listener_name
#     frontend_ip_configuration_name = var.appgw_fe_ip_config_name
#     frontend_port_name             = var.appgw_fe_port_name
#     protocol                       = "Http"
#   }

#   request_routing_rule {
#     name                       = var.appgw_request_routing_rule_name
#     rule_type                  = "Basic"
#     http_listener_name         = var.appgw_http_listener_name
#     backend_address_pool_name  = var.appgw_be_pool_name
#     backend_http_settings_name = var.appgw_be_http_setting_name
#     priority                   = "100"
#   }

# }
