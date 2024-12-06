##############################################################################
### Comentado recurso porque intenta destruirlo siempre
##############################################################################
#resource "azurerm_mssql_virtual_machine" "vm_slqserver_chl_databases_a" {
#  virtual_machine_id               = azurerm_windows_virtual_machine.vm_chl_databases_a.id
#  sql_license_type                 = "AHUB"
#  r_services_enabled               = false
#  sql_connectivity_port            = 1433
#  sql_connectivity_type            = "PRIVATE"
#  sql_connectivity_update_password = data.azurerm_key_vault_secret.vm_admin_cra_password.value
#  sql_connectivity_update_username = data.azurerm_key_vault_secret.vm_admin_cra_user.value
#
#
#  storage_configuration {
#    disk_type             = "NEW"  # (Required) The type of disk configuration to apply to the SQL Server. Valid values include NEW, EXTEND, or ADD.
#    storage_workload_type = "OLTP" # (Required) The type of storage workload. Valid values include GENERAL, OLTP, or DW.
#
#    # The storage_settings block supports the following:
#    data_settings {
#      default_file_path = "F:\\SQLDATA"
#      luns              = [0]
#    }
#
#    log_settings {
#      default_file_path = "G:\\SQLLOG"
#      luns              = [1]
#    }
#
#  }
#
#  sql_instance {
#    lock_pages_in_memory_enabled = true
#  }
#
#  tags = {
#    AC = local.actag
#  }
#
#  depends_on = [
#    azurerm_virtual_machine_data_disk_attachment.vm_chl_db_a_attach_data_disk_01,
#    azurerm_virtual_machine_data_disk_attachment.vm_chl_db_a_attach_data_disk_02
#  ]
#}

resource "azurerm_windows_virtual_machine" "vm_chl_databases_a" {
  name                     = "${local.prefix}-vm-chl-db-a"
  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
  location                 = local.az_location
  resource_group_name      = azurerm_resource_group.databases_vms_spoke002.name
  network_interface_ids    = [azurerm_network_interface.nic_vm_chl_databases_a.id]
  size                     = "Standard_D8as_v4"
  zone                     = 1
  computer_name            = "CLDC2SRP000001"
  patch_assessment_mode    = "AutomaticByPlatform"
  patch_mode               = "Manual"
  enable_automatic_updates = "false"
  license_type             = "Windows_Server"

  os_disk {
    name                 = "${local.prefix}-osdisk-vm-chl-db-a"
    caching              = "ReadWrite"
    disk_size_gb         = "128"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "microsoftsqlserver"
    offer     = "sql2019-ws2022"
    sku       = "standard-gen2"
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

resource "azurerm_managed_disk" "disk_datadisk01_vm_chl_db_a" {
  name                 = "${local.prefix}-datadisk01-vm-chl-db-a"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.databases_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1024"
  zone                 = "1"

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
      DiskType   = "SQLDATA"
    }
  )
}

resource "azurerm_managed_disk" "disk_datadisk02_vm_chl_db_a" {
  name                 = "${local.prefix}-datadisk02-vm-chl-db-a"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.databases_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  zone                 = "1"
  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
      DiskType   = "SQLLOG"
    }
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_chl_db_a_attach_data_disk_01" {
  managed_disk_id    = azurerm_managed_disk.disk_datadisk01_vm_chl_db_a.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_databases_a.id
  lun                = "0"
  caching            = "ReadOnly"
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_chl_db_a_attach_data_disk_02" {
  managed_disk_id    = azurerm_managed_disk.disk_datadisk02_vm_chl_db_a.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_databases_a.id
  lun                = "1"
  caching            = "None"
}

resource "azurerm_network_interface" "nic_vm_chl_databases_a" {
  name                = "${local.prefix}-nic-vm-chl-db-a"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.databases_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-db-a-ipconfig01"
    subnet_id                     = azurerm_subnet.snet_bbdds_spoke002.id
    private_ip_address_allocation = "Static"
  }
  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}



