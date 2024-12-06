############################################################
#### VIRTUAL MACHINE MASTERMIND EX 01
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_mastermind_ex_01" {
  name                     = "${local.prefix}-vm-chl-mex01"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.apps_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic-vm-chl-mex01.id]
  size                     = "Standard_D4s_v3"
  zone                     = 1
  computer_name            = "CLBRPROCRAMEX01"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-mex01"
    caching              = "ReadWrite"
    disk_size_gb         = "256"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


resource "azurerm_network_interface" "nic-vm-chl-mex01" {
  name                = "${local.prefix}-nic-vm-chl-mex01"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.apps_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-mex01-ipconfig01"
    subnet_id                     = azurerm_subnet.snet_apps_spoke002.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


############################################################
#### VIRTUAL MACHINE MASTERMIND EX 02
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_mastermind_ex_02" {
  name                     = "${local.prefix}-vm-chl-mex02"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.apps_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic-vm-chl-mex02.id]
  size                     = "Standard_D4s_v3"
  zone                     = 2
  computer_name            = "CLBRPROCRAMEX02"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-mex02"
    caching              = "ReadWrite"
    disk_size_gb         = "256"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


resource "azurerm_network_interface" "nic-vm-chl-mex02" {
  name                = "${local.prefix}-nic-vm-chl-mex02"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.apps_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-mex02-ipconfig01"
    subnet_id                     = azurerm_subnet.snet_apps_spoke002.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}
