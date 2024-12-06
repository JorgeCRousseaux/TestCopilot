############################################################
#### VIRTUAL MACHINE NEO DLS5
############################################################
resource "azurerm_windows_virtual_machine" "vm_chl_dls5_01" {
  name                     = "${local.prefix}-vm-chl-dls5-01"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.receivers_dls5_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic_vm_chl_dls5_01.id]
  size                     = "Standard_D4s_v3"
  zone                     = 1
  computer_name            = "CLBRPROCRADLS01"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-dls5-01"
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

resource "azurerm_network_interface" "nic_vm_chl_dls5_01" {
  name                = "${local.prefix}-nic-vm-chl-dls5-01"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_dls5_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-dls5-01-ipconfig01"
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

resource "azurerm_managed_disk" "disk_datadisk01_vm_chl_dls5_01" {
  name                 = "${local.prefix}-datadisk01-vm-chl-dls5-01"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.receivers_dls5_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  zone                 = "1"

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk01_attachment_vm_chl_dls5_01" {
  managed_disk_id    = azurerm_managed_disk.disk_datadisk01_vm_chl_dls5_01.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_dls5_01.id
  lun                = "0"
  caching            = "ReadWrite"
}
