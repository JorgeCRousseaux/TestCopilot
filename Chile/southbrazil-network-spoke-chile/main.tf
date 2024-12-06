locals {
  az_location              = "brazilsouth"
  az_location_abbreviation = "brs"
  environment              = "prod"
  project                  = "cra"
  region                   = "la"
  resource_prefix          = "${local.region}-${local.az_location_abbreviation}-${local.environment}"
  prefix                   = "${local.az_location_abbreviation}-${local.environment}-${local.project}"
  actag                    = "CL0053/L13A0/A211/CA300"
  tags = {
    Entorno    = upper(local.environment)
    Producto   = upper(local.project)
    Pais       = "CL"
    AC         = local.actag
    Creado     = "N/A"
    Modificado = "N/A"
  }
}


resource "azurerm_resource_group" "vnet_spoke_002" {
  name     = "${local.prefix}-rg-spoke-network002"
  location = local.az_location

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

####################################################################################
##### Resource groups for Chile - RSI receivers
####################################################################################
resource "azurerm_resource_group" "receivers_rsi_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-receivers-rsi-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

####################################################################################
##### Resource groups for Chile - DLS5 receivers
####################################################################################
resource "azurerm_resource_group" "receivers_dls5_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-receivers-dls5-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


####################################################################################
##### Resource groups for Chile - Climax receivers
####################################################################################
resource "azurerm_resource_group" "receivers_climax_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-receivers-climax-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

####################################################################################
##### Resource groups for Chile - Visonic receivers
####################################################################################
resource "azurerm_resource_group" "receivers_visonic_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-receivers-visonic-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

####################################################################################
##### Resource groups for Chile - Nanomir receivers
####################################################################################
resource "azurerm_resource_group" "receivers_nanomir_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-receivers-nanomir-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


####################################################################################
##### Resource groups for Chile - Signal Processors
####################################################################################
resource "azurerm_resource_group" "signal_processors_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-signal-processors-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


####################################################################################
##### Resource groups for Chile - Databases
####################################################################################
resource "azurerm_resource_group" "databases_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-databases-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

####################################################################################
##### Resource groups for Chile - APPS
####################################################################################
resource "azurerm_resource_group" "apps_vms_spoke002" {
  name     = "${local.prefix}-rg-vms-apps-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}

#####################################################################################
###### Resource group for backups
####################################################################################
resource "azurerm_resource_group" "backup" {
  name     = "${local.prefix}-rg-backups-spoke002"
  location = local.az_location

  tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}
