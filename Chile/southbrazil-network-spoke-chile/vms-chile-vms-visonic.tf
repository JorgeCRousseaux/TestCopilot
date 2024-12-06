resource "azurerm_network_interface" "nic_vm_chl_visonic_01" {
  name                = "${local.prefix}-nic-vm-chl-visonic-01"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_visonic_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-visonic-01-ipconfig01"
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

resource "azurerm_network_interface" "nic_vm_chl_visonic_02" {
  name                = "${local.prefix}-nic-vm-chl-visonic-02"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.receivers_visonic_vms_spoke002.name

  ip_configuration {
    name                          = "vm-chl-visonic-02-ipconfig01"
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