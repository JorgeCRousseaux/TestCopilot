############################################################
#### VIRTUAL MACHINE RSIA
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_rsia" {
  name                     = "${local.prefix}-vm-chl-rsia"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.receivers_rsi_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic-vm-chl-rsia.id]
  size                     = "Standard_D4s_v3"
  zone                     = 1
  computer_name            = "CLBRPROCRARSIA"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-rsia"
    caching              = "ReadWrite"
    disk_size_gb         = "128"
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

resource "azurerm_network_interface" "nic-vm-chl-rsia" {
  name                = "${local.prefix}-nic-vm-chlrsia"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_rsi_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chlrsia-ipconfig01"
    subnet_id                     = azurerm_subnet.snet_receivers_spoke002.id
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

resource "azurerm_managed_disk" "disk-datadisk01-vm-chl-rsia" {
  name                 = "${local.prefix}-datadisk01-vm-chlrsia"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.receivers_rsi_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "128"
  zone                 = "1"

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_chl_rsia" {
  managed_disk_id    = azurerm_managed_disk.disk-datadisk01-vm-chl-rsia.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_rsia.id
  lun                = "0"
  caching            = "ReadWrite"
}

############################################################
#### VIRTUAL MACHINE RSIB
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_rsib" {
  name                     = "${local.prefix}-vm-chl-rsib"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.receivers_rsi_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic-vm-chl-rsib.id]
  size                     = "Standard_D4s_v3"
  zone                     = 2
  computer_name            = "CLBRPROCRARSIB"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-rsib"
    caching              = "ReadWrite"
    disk_size_gb         = "128"
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

resource "azurerm_network_interface" "nic-vm-chl-rsib" {
  name                = "${local.prefix}-nic-vm-chlrsib"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_rsi_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chlrsia-ipconfig01"
    subnet_id                     = azurerm_subnet.snet_receivers_spoke002.id
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

resource "azurerm_managed_disk" "disk-datadisk01-vm-chl-rsib" {
  name                 = "${local.prefix}-datadisk01-vm-chlrsib"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.receivers_rsi_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "128"
  zone                 = "2"

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_chl_rsib" {
  managed_disk_id    = azurerm_managed_disk.disk-datadisk01-vm-chl-rsib.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_rsib.id
  lun                = "0"
  caching            = "ReadWrite"
}


############################################################
#### VIRTUAL MACHINE TMTA
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_tmta" {
  name                     = "${local.prefix}-vm-chl-tmta"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.receivers_rsi_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic-vm-chl-tmta.id]
  size                     = "Standard_D4s_v3"
  zone                     = 1
  computer_name            = "CLBRPROCRATMTA"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-tmta"
    caching              = "ReadWrite"
    disk_size_gb         = "128"
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

resource "azurerm_network_interface" "nic-vm-chl-tmta" {
  name                = "${local.prefix}-nic-vm-chltmta"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_rsi_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chlrsia-ipconfig01"
    subnet_id                     = azurerm_subnet.snet_receivers_spoke002.id
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

resource "azurerm_managed_disk" "disk-datadisk01-vm-chl-tmta" {
  name                 = "${local.prefix}-datadisk01-vm-chltmta"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.receivers_rsi_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "128"
  zone                 = "1"

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_chl_tmta" {
  managed_disk_id    = azurerm_managed_disk.disk-datadisk01-vm-chl-tmta.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_tmta.id
  lun                = "0"
  caching            = "ReadWrite"
}

