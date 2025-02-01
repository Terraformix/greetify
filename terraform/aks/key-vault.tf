resource "azurerm_key_vault" "this" {
  name = local.key_vault_name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location

  tenant_id = var.tenant_id
  purge_protection_enabled = false
  sku_name = "standard"
  soft_delete_retention_days = 7

  enable_rbac_authorization = true
}
