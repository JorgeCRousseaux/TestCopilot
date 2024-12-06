############################################################
#### VIRTUAL MACHINE CLIMAX 01
############################################################
resource "azurerm_linux_virtual_machine" "vm_chl_climax_01" {
  name                            = "${local.prefix}-vm-chl-climax-01"
  computer_name                   = "CLBRPROCRACLI01"
  admin_username                  = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password                  = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                        = local.az_location
  resource_group_name             = azurerm_resource_group.receivers_climax_vms_spoke002.name
  network_interface_ids           = [azurerm_network_interface.nic_vm_chl_climax_01.id]
  size                            = "Standard_D4s_v3"
  disable_password_authentication = false
  zone                            = 1

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-climax-01"
    caching              = "ReadWrite"
    disk_size_gb         = "128"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "93-gen2"
    version   = "latest"
  }

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )

  lifecycle {
    ignore_changes = [
      computer_name
    ]
  }
}

resource "azurerm_network_interface" "nic_vm_chl_climax_01" {
  name                = "${local.prefix}-nic-vm-chl-climax-01"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_climax_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-climax-01-ipconfig01"
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

resource "azurerm_managed_disk" "disk_datadisk01_vm_chl_climax_01" {
  name                 = "${local.prefix}-datadisk01-vm-chl-climax-01"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.receivers_climax_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"
  zone                 = "1"


    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk01_attachment_vm_chl_climax_01" {
  managed_disk_id    = azurerm_managed_disk.disk_datadisk01_vm_chl_climax_01.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_chl_climax_01.id
  lun                = "0"
  caching            = "ReadWrite"
}


############################################################
#### VIRTUAL MACHINE CLIMAX 02
############################################################
resource "azurerm_linux_virtual_machine" "vm_chl_climax_02" {
  name                            = "${local.prefix}-vm-chl-climax-02"
  computer_name                   = "CLBRPROCRACLI02"
  admin_username                  = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password                  = "-sr3*F7[!55C"
  location                        = local.az_location
  resource_group_name             = azurerm_resource_group.receivers_climax_vms_spoke002.name
  network_interface_ids           = [azurerm_network_interface.nic_vm_chl_climax_02.id]
  size                            = "Standard_D4s_v3"
  disable_password_authentication = false
  zone                            = 2

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-climax-02"
    caching              = "ReadWrite"
    disk_size_gb         = "128"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "93-gen2"
    version   = "latest"
  }

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )

  lifecycle {
    ignore_changes = [
      computer_name
    ]
  }
}

resource "azurerm_network_interface" "nic_vm_chl_climax_02" {
  name                = "${local.prefix}-nic-vm-chl-climax-02"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_climax_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-climax-02-ipconfig01"
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

resource "azurerm_managed_disk" "disk_datadisk01_vm_chl_climax_02" {
  name                 = "${local.prefix}-datadisk01-vm-chl-climax-02"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.receivers_climax_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"
  zone                 = "2"


    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk01_attachment_vm_chl_climax_02" {
  managed_disk_id    = azurerm_managed_disk.disk_datadisk01_vm_chl_climax_02.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_chl_climax_02.id
  lun                = "0"
  caching            = "ReadWrite"
}