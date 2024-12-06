#################################################################
##### LOAD BALANCER FOR MASTERMIND MOBILE AND EX FOR CHILE
#################################################################
resource "azurerm_lb" "lbi_vnet_spoke002_apps_mex" {
  name                = "${local.prefix}-lbi-vnet-spoke002-apps-mex"
  location            = azurerm_resource_group.vnet_spoke_002.location
  resource_group_name = azurerm_resource_group.vnet_spoke_002.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "lbi-vnet-spoke002-apps-mex-ipconfig01"
    subnet_id                     = azurerm_subnet.snet_apps_spoke002.id
    private_ip_address_allocation = "Dynamic"
    zones                         = ["1", "2", "3"]
  }

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

############################################################################
#######
###########################################################################
resource "azurerm_lb_backend_address_pool" "lbbp_vnet_spoke002_apps_mex" {
  loadbalancer_id = azurerm_lb.lbi_vnet_spoke002_apps_mex.id
  name            = "lbbp-vnet-spoke002-apps-mex"

  depends_on = [azurerm_lb.lbi_vnet_spoke002_apps_mex]

}

resource "azurerm_network_interface_backend_address_pool_association" "lbbp_nic_assoc_vnet_spoke002_apps_mex01" {
  network_interface_id    = azurerm_network_interface.nic-vm-chl-mex01.id
  ip_configuration_name   = "vm-chl-mex01-ipconfig01"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbp_vnet_spoke002_apps_mex.id
}

resource "azurerm_network_interface_backend_address_pool_association" "lbbp_nic_assoc_vnet_spoke002_apps_mex02" {
  network_interface_id    = azurerm_network_interface.nic-vm-chl-mex02.id
  ip_configuration_name   = "vm-chl-mex02-ipconfig01"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lbbp_vnet_spoke002_apps_mex.id
}


######################################################################
#### LOAD BALANCER PROBE FOR MAS EX
######################################################################
resource "azurerm_lb_probe" "lbp_vnet_spoke002_apps_mas_ex" {
  loadbalancer_id  = azurerm_lb.lbi_vnet_spoke002_apps_mex.id
  name             = "Probe-Port-4510"
  port             = 4510
  number_of_probes = 1

  depends_on = [azurerm_lb.lbi_vnet_spoke002_apps_mex]

}

######################################################################
#### LOAD BALANCER PROBE FOR MAS MOBILE
######################################################################
resource "azurerm_lb_probe" "lbp_vnet_spoke002_apps_mas_mobile" {
  loadbalancer_id = azurerm_lb.lbi_vnet_spoke002_apps_mex.id
  name            = "Probe-Port-45540"
  port            = 45540

  depends_on = [azurerm_lb.lbi_vnet_spoke002_apps_mex]

}


################################################################
######## LOAD BALANCER RULE FOR MAS MOBILE
################################################################
resource "azurerm_lb_rule" "lbr_vnet_spoke002_apps_me" {
  loadbalancer_id                = azurerm_lb.lbi_vnet_spoke002_apps_mex.id
  name                           = "Rule-Port-45540"
  protocol                       = "Tcp"
  frontend_port                  = 45540
  backend_port                   = 45540
  disable_outbound_snat          = true
  frontend_ip_configuration_name = "lbi-vnet-spoke002-apps-mex-ipconfig01"
  probe_id                       = azurerm_lb_probe.lbp_vnet_spoke002_apps_mas_mobile.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lbbp_vnet_spoke002_apps_mex.id]

  depends_on = [azurerm_lb.lbi_vnet_spoke002_apps_mex]
}


################################################################
######## LOAD BALANCER RULE FOR MAS EX
################################################################
resource "azurerm_lb_rule" "lbr_vnet_spoke002_apps_mex" {
  loadbalancer_id                = azurerm_lb.lbi_vnet_spoke002_apps_mex.id
  name                           = "Rule-Port-4510"
  protocol                       = "Tcp"
  frontend_port                  = 4510
  backend_port                   = 4510
  disable_outbound_snat          = true
  frontend_ip_configuration_name = "lbi-vnet-spoke002-apps-mex-ipconfig01"
  probe_id                       = azurerm_lb_probe.lbp_vnet_spoke002_apps_mas_ex.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lbbp_vnet_spoke002_apps_mex.id]

  depends_on = [azurerm_lb.lbi_vnet_spoke002_apps_mex]
}