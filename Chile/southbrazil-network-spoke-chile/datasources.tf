#################################################################
############## Key vault secrets
#################################################################
data "azurerm_key_vault" "terraform_vault" {
  name                = "la-brs-prod-kv-terraform"
  resource_group_name = "la-brs-prod-rg-terraform"
  provider            = azurerm.network
}

data "azurerm_key_vault_secret" "vm_admin_cra_user" {
  name         = "vm-admin-cra-user"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
  provider     = azurerm.network
}


data "azurerm_key_vault_secret" "vm_admin_cra_password" {
  name         = "vm-admin-cra-password"
  key_vault_id = data.azurerm_key_vault.terraform_vault.id
  provider     = azurerm.network
}


#################################################################
#### Network Hub Information
#################################################################
data "azurerm_virtual_network" "network_hub" {
  name                = "brs-prod-cra-vnet-hub"
  resource_group_name = "brs-prod-cra-rg-hub-network"
  provider            = azurerm.network
}