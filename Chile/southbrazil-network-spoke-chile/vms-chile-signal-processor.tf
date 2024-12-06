############################################################
#### VIRTUAL MACHINE SIGNAL PROCESSOR 01
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_signal_processor_01" {
  name                     = "${local.prefix}-vm-chl-sp01"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.signal_processors_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic_vm_chl_signal_processor_01.id]
  size                     = "Standard_D4s_v3"
  zone                     = 1
  computer_name            = "CLBRPROCRAMSP01"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-sp01"
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

resource "azurerm_network_interface" "nic_vm_chl_signal_processor_01" {
  name                = "${local.prefix}-nic-vm-chl-sp01"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.signal_processors_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-sp01-ipconfig01"
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

############################################################
#### VIRTUAL MACHINE SIGNAL PROCESSOR 02
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_signal_processor_02" {
  name                     = "${local.prefix}-vm-chl-sp02"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.signal_processors_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic_vm_chl_signal_processor_02.id]
  size                     = "Standard_D4s_v3"
  zone                     = 2
  computer_name            = "CLBRPROCRAMSP02"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-sp02"
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

resource "azurerm_network_interface" "nic_vm_chl_signal_processor_02" {
  name                = "${local.prefix}-nic-vm-chl-sp02"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.signal_processors_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-sp02-ipconfig01"
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


############################################################
#### VIRTUAL MACHINE SIGNAL PROCESSOR 03
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_signal_processor_03" {
  name                     = "${local.prefix}-vm-chl-sp03"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.signal_processors_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic_vm_chl_signal_processor_03.id]
  size                     = "Standard_D4s_v3"
  zone                     = 1
  computer_name            = "CLBRPROCRAMSP03"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-sp03"
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

resource "azurerm_network_interface" "nic_vm_chl_signal_processor_03" {
  name                = "${local.prefix}-nic-vm-chl-sp03"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.signal_processors_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-sp03-ipconfig01"
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