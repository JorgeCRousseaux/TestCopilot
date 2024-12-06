#####################################################
#### VIRTUAL NETWORK FOR SPOKE 002 NETWORK
#####################################################
resource "azurerm_virtual_network" "vnet_spoke_002" {
  name                = "${local.prefix}-vnet-spoke002"
  location            = azurerm_resource_group.vnet_spoke_002.location
  resource_group_name = azurerm_resource_group.vnet_spoke_002.name
  address_space       = ["10.248.132.0/24"]

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


######################################################################
##### Subnets
######################################################################
resource "azurerm_subnet" "snet_receivers_spoke002" {
  name                 = "${local.prefix}-snet-receivers"
  resource_group_name  = azurerm_resource_group.vnet_spoke_002.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke_002.name
  address_prefixes     = ["10.248.132.0/26"]
}

resource "azurerm_subnet" "snet_apps_spoke002" {
  name                 = "${local.prefix}-snet-apps"
  resource_group_name  = azurerm_resource_group.vnet_spoke_002.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke_002.name
  address_prefixes     = ["10.248.132.128/27"]
}

resource "azurerm_subnet" "snet_bbdds_spoke002" {
  name                 = "${local.prefix}-snet-db"
  resource_group_name  = azurerm_resource_group.vnet_spoke_002.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke_002.name
  address_prefixes     = ["10.248.132.192/27"]
}


###############################################################################
##### Peering with Hub Network
###############################################################################
resource "azurerm_virtual_network_peering" "hub_peering_network" {
  name                      = "${local.prefix}-vnet-peer-from-spoke002-to-hub"
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  resource_group_name       = azurerm_resource_group.vnet_spoke_002.name
  virtual_network_name      = azurerm_virtual_network.vnet_spoke_002.name
  remote_virtual_network_id = data.azurerm_virtual_network.network_hub.id

  use_remote_gateways = true
}

#############################################
### ROUTE TABLES for Subnets to Firewall
#############################################
resource "azurerm_route_table" "route_table_vnet_spoke002" {
  name                          = "${local.prefix}-rt-snet-spoke002"
  location                      = local.az_location
  resource_group_name           = azurerm_resource_group.vnet_spoke_002.name
  disable_bgp_route_propagation = true

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_route" "route_to_firewall_vnet_spoke002" {
  name                   = "ToFirewall"
  resource_group_name    = azurerm_resource_group.vnet_spoke_002.name
  route_table_name       = azurerm_route_table.route_table_vnet_spoke002.name
  address_prefix         = "0.0.0.0/0"
  next_hop_in_ip_address = "10.248.128.4"
  next_hop_type          = "VirtualAppliance"
}

resource "azurerm_subnet_route_table_association" "route_assoc_snet_bbds_spoke002" {
  subnet_id      = azurerm_subnet.snet_bbdds_spoke002.id
  route_table_id = azurerm_route_table.route_table_vnet_spoke002.id
}

resource "azurerm_subnet_route_table_association" "route_assoc_snet_apps_spoke002" {
  subnet_id      = azurerm_subnet.snet_apps_spoke002.id
  route_table_id = azurerm_route_table.route_table_vnet_spoke002.id
}

resource "azurerm_subnet_route_table_association" "route_assoc_snet_receivers_spoke002" {
  subnet_id      = azurerm_subnet.snet_receivers_spoke002.id
  route_table_id = azurerm_route_table.route_table_vnet_spoke002.id
}

###########################################################################################
######## NETWORK SECURITY GROUPS
###########################################################################################
################################################
######## Security group for Receivers Subnet
################################################
resource "azurerm_network_security_group" "nsg_subnet_receivers_vnet_spoke002" {
  name                = "${local.prefix}-nsg-snet-receivers-vnet-spoke002"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.vnet_spoke_002.name
    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_subnet_network_security_group_association" "nsga_subnet_receivers_vnet_spoke002" {
  subnet_id                 = azurerm_subnet.snet_receivers_spoke002.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_receivers_vnet_spoke002.id
}


resource "azurerm_network_security_rule" "nsr_subnet_receivers_allow_visonic_receivers" {
  name                         = "AllowInboundManagementToVisonicReceivers"
  description                  = "Access Visonic Receivers from management VMs"
  priority                     = 990
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["443", "2200"]
  source_address_prefix        = "10.248.137.0/28"
  destination_address_prefixes = ["10.248.132.12"]
  resource_group_name          = azurerm_resource_group.vnet_spoke_002.name
  network_security_group_name  = azurerm_network_security_group.nsg_subnet_receivers_vnet_spoke002.name
}

resource "azurerm_network_security_rule" "nsr_subnet_receivers_allow_climax_receivers" {
  name                         = "AllowInboundManagementToClimaxReceivers"
  description                  = "Access Climax Receivers from management VMs"
  priority                     = 1000
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["8899"]
  source_address_prefix        = "10.248.137.0/28"
  destination_address_prefixes = ["10.248.132.9", "10.248.132.10"]
  resource_group_name          = azurerm_resource_group.vnet_spoke_002.name
  network_security_group_name  = azurerm_network_security_group.nsg_subnet_receivers_vnet_spoke002.name
}

resource "azurerm_network_security_rule" "nsr_subnet_receivers_allow_panels_nanomir" {
  name                         = "AllowInboundPanelsNanomirToNanomirReceivers"
  description                  = "Ports used for Nanomir Panels"
  priority                     = 4076
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Udp"
  source_port_ranges           = ["7050", "7051"]
  destination_port_ranges      = ["7050", "7051"]
  source_address_prefix        = "10.248.128.4"
  destination_address_prefixes = ["10.248.132.14", "10.248.132.15"]
  resource_group_name          = azurerm_resource_group.vnet_spoke_002.name
  network_security_group_name  = azurerm_network_security_group.nsg_subnet_receivers_vnet_spoke002.name
}

resource "azurerm_network_security_rule" "nsr_subnet_receivers_allow_mobility_aws" {
  name                        = "AllowMobilityAWSToSignalProcessor01"
  description                 = "Port used for Mobility AWS"
  priority                    = 4086
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "45056"
  destination_port_ranges     = ["45056"]
  source_address_prefix       = "10.248.128.4"
  destination_address_prefix  = "10.248.132.8"
  resource_group_name         = azurerm_resource_group.vnet_spoke_002.name
  network_security_group_name = azurerm_network_security_group.nsg_subnet_receivers_vnet_spoke002.name
}

resource "azurerm_network_security_rule" "nsr_subnet_receivers_allow_panels_dls" {
  name                        = "AllowInboundPanelsDLSToDLSReceiver"
  description                 = "Port used for Panels DLS"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "51004"
  destination_port_ranges     = ["51004"]
  source_address_prefix       = "10.248.128.4"
  destination_address_prefix  = "10.248.132.8"
  resource_group_name         = azurerm_resource_group.vnet_spoke_002.name
  network_security_group_name = azurerm_network_security_group.nsg_subnet_receivers_vnet_spoke002.name
}


############################################
######## Security group for BBDDS Subnet
############################################
resource "azurerm_network_security_group" "nsg_subnet_dbs_vnet_spoke002" {
  name                = "${local.prefix}-nsg-snet-db-vnet-spoke002"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.vnet_spoke_002.name
    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_subnet_network_security_group_association" "nsga_subnet_dbs_vnet_spoke002" {
  subnet_id                 = azurerm_subnet.snet_bbdds_spoke002.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_dbs_vnet_spoke002.id
}


#resource "azurerm_network_security_rule" "nsr_subnet_monitoring_allow_ports_obm" {
#  name              = "AllowPortsUsedForRSIPanels"
#  description       = "Ports used for Operation Bridge Manager"
#  priority          = 10000
#  direction         = "Inbound"
#  access            = "Allow"
#  protocol          = "*"
#  source_port_ranges = ["888"]
#  destination_port_ranges = ["*"]
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.nsg_subnet_receivers_vnet_spoke002.name
#  network_security_group_name = azurerm_network_security_group.nsg_subnet_receivers_vnet_spoke002.name
#}


############################################
######## Security group for Apps Subnet
############################################
resource "azurerm_network_security_group" "nsg_subnet_apps_vnet_spoke002" {
  name                = "${local.prefix}-nsg-snet-apps-vnet-spoke002"
  location            = local.az_location
  resource_group_name = azurerm_resource_group.vnet_spoke_002.name
    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

resource "azurerm_subnet_network_security_group_association" "nsga_subnet_apps_vnet_spoke002" {
  subnet_id                 = azurerm_subnet.snet_apps_spoke002.id
  network_security_group_id = azurerm_network_security_group.nsg_subnet_apps_vnet_spoke002.id
}