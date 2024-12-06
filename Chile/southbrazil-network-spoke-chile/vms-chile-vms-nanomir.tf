############################################################
#### VIRTUAL MACHINE NANOMIR 01
############################################################

#resource "azurerm_virtual_machine" "vm_chl_nanomir_01" {
#
#  name                  = "${local.prefix}-vm-chl-nanomir-01"
#  location              = azurerm_resource_group.receivers_nanomir_vms_spoke002.location
#  resource_group_name   = azurerm_resource_group.receivers_nanomir_vms_spoke002.name
#  network_interface_ids = [azurerm_network_interface.nic_vm_chl_nanomir_01.id]
#  vm_size               = "Standard_D2as_v4"
#
#  delete_data_disks_on_termination = false
#  delete_os_disk_on_termination    = false
#
#  boot_diagnostics {
#    enabled     = true
#    storage_uri = ""
#  }
#
#  storage_os_disk {
#    name              = "brs-prod-cra-osdisk-vm-chl-nanomir-01"
#    caching           = "ReadWrite"
#    create_option     = "Attach"
#    disk_size_gb      = 128
#    managed_disk_type = "Premium_LRS"
#    os_type           = "Windows"
#  }
#
#  zones = ["1"]
#
#  lifecycle {
#    ignore_changes = [boot_diagnostics[0].storage_uri, primary_network_interface_id,additional_capabilities]
#  }
#}


resource "azurerm_network_interface" "nic_vm_chl_nanomir_01" {
  name                = "${local.prefix}-nic-vm-chl-nanomir-01"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_nanomir_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-nanomir-01-ipconfig01"
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
#### VIRTUAL MACHINE NANOMIR 02
############################################################

resource "azurerm_managed_disk" "disk_datadisk01_vm_chl_nanomir_02" {
  name                 = "${local.prefix}-datadisk01-vm-chl-nanomir-02"
  location             = local.az_location
  resource_group_name  = azurerm_resource_group.receivers_nanomir_vms_spoke002.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Copy"
  source_resource_id   = "/subscriptions/60cec702-2c0a-4ccc-9b26-04b3509cd971/resourceGroups/brs-prod-cra-rg-vms-receivers-nanomir-spoke002/providers/Microsoft.Compute/snapshots/snap-brs-prod-cra-datadisk01-vm-chl-nanomir-02"
  disk_size_gb         = "32"
  zone                 = "2"

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_network_interface" "nic_vm_chl_nanomir_02" {
  name                = "${local.prefix}-nic-vm-chl-nanomir-02"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_nanomir_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-nanomir-02-ipconfig01"
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

