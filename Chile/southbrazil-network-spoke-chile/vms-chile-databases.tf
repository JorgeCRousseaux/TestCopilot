#resource "azurerm_mssql_virtual_machine" "vm_slqserver_chl_databases_01" {
#  virtual_machine_id               = azurerm_windows_virtual_machine.vm_chl_databases_01.id
#  sql_license_type                 = "PAYG"
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
#}
#
#resource "azurerm_windows_virtual_machine" "vm_chl_databases_01" {
#  name                     = "${local.prefix}-vm-chl-dba"
#  admin_username           = data.azurerm_key_vault_secret.vm_admin_cra_user.value
#  admin_password           = data.azurerm_key_vault_secret.vm_admin_cra_password.value
#  location                 = local.az_location
#  resource_group_name      = azurerm_resource_group.databases_vms_spoke002.name
#  network_interface_ids    = [azurerm_network_interface.nic_vm_chl_databases_01.id]
#  size                     = "Standard_D4s_v3"
#  zone                     = 1
#  computer_name            = "CLBRPROCRAMDBA"
#  patch_assessment_mode    = "AutomaticByPlatform"
#  patch_mode               = "Manual"
#  enable_automatic_updates = "false"
#
#  os_disk {
#    name                 = "${local.prefix}-osdisk-vm-chl-dba"
#    caching              = "ReadWrite"
#    disk_size_gb         = "128"
#    storage_account_type = "StandardSSD_LRS"
#  }
#
#  source_image_reference {
#    publisher = "microsoftsqlserver"
#    offer     = "sql2019-ws2022"
#    sku       = "web-gen2"
#    version   = "latest"
#  }
#
#  tags = {
#    Environment = local.environment
#    Project     = local.project
#    Country     = "Chile"
#    Status      = "Reborn"
#    AC          = local.actag
#  }
#
#}
#
#resource "azurerm_managed_disk" "disk_datadisk01_vm_chl_dba" {
#  name                 = "${local.prefix}-datadisk01-vm-chl-dba"
#  location             = local.az_location
#  resource_group_name  = azurerm_resource_group.databases_vms_spoke002.name
#  storage_account_type = "StandardSSD_LRS"
#  create_option        = "Empty"
#  disk_size_gb         = "512"
#  zone                 = "1"
#
#  tags = {
#    Environment = local.environment
#    Project     = local.project
#    Country     = "Chile"
#    Status      = "Reborn",
#    DiskType    = "SQLDATA"
#    AC          = local.actag
#  }
#}
#
#resource "azurerm_managed_disk" "disk_datadisk02_vm_chl_dba" {
#  name                 = "${local.prefix}-datadisk02-vm-chl-dba"
#  location             = local.az_location
#  resource_group_name  = azurerm_resource_group.databases_vms_spoke002.name
#  storage_account_type = "StandardSSD_LRS"
#  create_option        = "Empty"
#  disk_size_gb         = "256"
#  zone                 = "1"
#  tags = {
#    Environment = local.environment
#    Project     = local.project
#    Country     = "Chile"
#    Status      = "Reborn",
#    DiskType    = "SQLLOG"
#    AC          = local.actag
#  }
#}
#
#resource "azurerm_virtual_machine_data_disk_attachment" "vm_chl_dba_attach_data_disk_01" {
#  managed_disk_id    = azurerm_managed_disk.disk_datadisk01_vm_chl_dba.id
#  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_databases_01.id
#  lun                = "0"
#  caching            = "ReadWrite"
#}
#
#resource "azurerm_virtual_machine_data_disk_attachment" "vm_chl_dba_attach_data_disk_02" {
#  managed_disk_id    = azurerm_managed_disk.disk_datadisk02_vm_chl_dba.id
#  virtual_machine_id = azurerm_windows_virtual_machine.vm_chl_databases_01.id
#  lun                = "1"
#  caching            = "ReadWrite"
#}
#
#resource "azurerm_network_interface" "nic_vm_chl_databases_01" {
#  name                = "${local.prefix}-nic-vm-chl-dba"
#  location            = local.az_location
#  resource_group_name = azurerm_resource_group.databases_vms_spoke002.name
#
#  ip_configuration {
#    name                          = "vm-chl-dba-ipconfig01"
#    subnet_id                     = azurerm_subnet.snet_bbdds_spoke002.id
#    private_ip_address_allocation = "Dynamic"
#  }
#  tags = {
#    AC = local.actag
#  }
#}
#
#
#
#