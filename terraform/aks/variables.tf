variable "subscription_id" {
  type        = string
}

variable "client_id" {
  type        = string
}

variable "client_secret" {
  type        = string
}

variable "tenant_id" {
  type        = string
}

variable "location" {
  type        = string
  default     = "centralus"
}

variable "gh_actions_runner_registration_token" {
  type        = string
}

variable "gh_actions_service_principal_name" {
  type        = string
  default     = "gh-actions-demo"
}



variable "tf_service_principal_name" {
  type        = string
  default     = "terraform-sp"
}

variable "resource_group_name" {
  type        = string
  default     = "greetify"
}

variable "agent_vm_name" {
  type        = string
  default     = "agent-vm"
}

variable "agent_vm_username" {
  type        = string
  default     = "localadmin"
}

variable "agent_vm_password" {
  type        = string
  default     = "p@ssw0rd12345"
}


variable "agent_vm_public_ip_name" {
  type        = string
  default     = "agent-public-ip"
}

variable "registry_password" {
  type        = string
  default     = "p@ssw0rd12345"
  sensitive = true
}

variable "namespace" {
  type        = string
  default     = "greetify"
}


variable "password" {
  type        = string
  default     = "p@ssw0rd12345"
}

variable "aks_name" {
  type        = string
  default     = "greetifyaks"
}

variable "aks_law_name" {
  type        = string
  default     = "aks-monitoring"
}

variable "acr_name" {
  type        = string
  default     = "greetifyacr"
}

variable "sql_admin_login" {
  type        = string
  default     = "localadmin"
}


variable "sql_admin_password" {
  type        = string
  default     = "p@ssw0rd12345"
}

variable "key_vault_name" {
  type        = string
  default     = "greetifykv"
}

variable "vnet_name" {
  type        = string
  default     = "vnet"
}

variable "sql_server_name" {
  type        = string
  default     = "greetifysql"
}

variable "sql_db_name" {
  type        = string
  default     = "GreetifyDB"
}

variable "default_subnet_name" {
  type        = string
  default     = "default"
}

variable "appgw_subnet_name" {
  type        = string
  default     = "appgw"
}

variable "aks_sku_tier" {
  type        = string
  default     = "Free"
}

variable "appgw_name" {
  type        = string
  default     = "aks-ingress-app-gw"
}

variable "appgw_fe_public_ip_name" {
  type        = string
  default     = "app-gw-fe-public-ip"
}


variable "appgw_ip_config_name" {
  type        = string
  default     = "gateway-ip-config"
}

variable "appgw_fe_ip_config_name" {
  type        = string
  default     = "fe-ip-config"
}

variable "appgw_fe_port_name" {
  type        = string
  default     = "fe-port"
}

variable "appgw_be_pool_name" {
  type        = string
  default     = "be-pool"
}

variable "appgw_request_routing_rule_name" {
  type        = string
  default     = "request-routing-rule"
}

variable "appgw_be_http_setting_name" {
  type        = string
  default     = "be-http-setting"
}

variable "appgw_http_listener_name" {
  type        = string
  default     = "http-listener"
}


variable "common_tags" {
  type        = map(string)
  default = {
    "Environment" = "Development",
    "Department"  = "IT"
  }
}