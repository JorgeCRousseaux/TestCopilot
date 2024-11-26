#! VM
#! Especificar entre si es windows o linux
#! especificar nic
#! opcional datadisk mediante un mapa

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

#? WINDOWS
#* OPTIONAL
resource "azurerm_windows_virtual_machine" "name" {
  count = var.windows != null ? 1:0
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  computer_name            = var.windows.computer_name
  enable_automatic_updates = var.windows.enable_automatic_updates
  location                 = var.location
  name                     = var.windows.name
  license_type             = try(var.windows.license_type,null)
  network_interface_ids    = [azurerm_network_interface.name.id]
  patch_assessment_mode    = var.windows.patch_assessment_mode
  patch_mode               = var.windows.patch_mode
  resource_group_name      = var.resource_group_name
  size                     = var.windows.size
  zone                     = var.windows.zone

  os_disk {
    caching              = var.windows.os_disk.caching
    disk_size_gb         = var.windows.os_disk.disk_size_gb
    name                 = var.windows.os_disk.name
    storage_account_type = var.windows.os_disk.storage_account_type
  }

  source_image_reference {
    offer     = var.windows.source_image_reference.offer
    publisher = var.windows.source_image_reference.publisher
    sku       = var.windows.source_image_reference.sku
    version   = var.windows.source_image_reference.version
  }

  tags = var.tags
}

#? LINUX
#* OPTIONAL
resource "azurerm_linux_virtual_machine" "name" {
  count = var.linux != null ? 1:0

  admin_password                  = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  admin_username                  = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  computer_name                   = var.linux.computer_name
  disable_password_authentication = var.linux.disable_password_authentication
  location                        = var.location
  name                            = var.linux.name
  network_interface_ids           = [azurerm_network_interface.name.id]
  resource_group_name             = var.resource_group_name
  size                            = var.linux.size
  zone                            = var.linux.zone

  os_disk {
    caching              = var.linux.os_disk.caching
    disk_size_gb         = var.linux.os_disk.disk_size_gb
    name                 = var.linux.os_disk.name
    storage_account_type = var.linux.os_disk.storage_account_type
  }

  source_image_reference {
    offer     = var.linux.source_image_reference.offer
    publisher = var.linux.source_image_reference.publisher
    sku       = var.linux.source_image_reference.sku
    version   = var.linux.source_image_reference.version
  }

  tags = var.tags

}

#? NIC
resource "azurerm_network_interface" "name" {
  location            = var.location
  name                = var.nic.name
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = var.nic.ip_configuration.name
    subnet_id                     = var.nic.ip_configuration.subnet_id
    private_ip_address_allocation = var.nic.ip_configuration.private_ip_address_allocation
    private_ip_address            = var.nic.ip_configuration.private_ip_address_allocation == "Static" ? var.nic.ip_configuration.private_ip_address:null
  }
  tags = var.tags
}



#? DATA DISK
#* OPTIONAL
resource "azurerm_managed_disk" "name" {
  for_each = var.disks

  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  location             = var.location
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  zone                 = each.value.zone
  tags = var.tags
}
#? DATA DISK ATTACHMENT
#* OPTIONAL
resource "azurerm_virtual_machine_data_disk_attachment" "name" {
    for_each = var.disks

    managed_disk_id    = azurerm_managed_disk.name[each.key].id
    caching            = each.value.caching
    lun                = each.value.lun
    virtual_machine_id = var.windows != null ? azurerm_windows_virtual_machine.name[0].id : azurerm_linux_virtual_machine.name[0].id
}