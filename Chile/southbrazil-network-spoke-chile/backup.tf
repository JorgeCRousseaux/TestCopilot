resource "azurerm_recovery_services_vault" "recovery_services_vault" {
  name                = "${local.prefix}-rsv-chl"
  location            = azurerm_resource_group.backup.location
  resource_group_name = azurerm_resource_group.backup.name
  sku                 = "Standard"

  soft_delete_enabled = true

  storage_mode_type = "ZoneRedundant"

    tags = merge(
    local.tags,
    {
      Creado     = "N/A"
      Modificado = "N/A"
    }
  )
}


resource "azurerm_backup_policy_vm" "backup_policy_production" {
  name                = "ProductionBackupPolicy"
  resource_group_name = azurerm_resource_group.backup.name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 15
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 6
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }

  instant_restore_resource_group {
    prefix = "${local.prefix}-backup-instant-recovery"
    suffix = "spoke002"
  }

}

##########################################################################
######## BACKUP MASTERMIND EX 01
##########################################################################

resource "azurerm_backup_protected_vm" "vm_chl_mastermind_ex_01" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_mastermind_ex_01.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP MASTERMIND EX 02
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_mastermind_ex_02" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_mastermind_ex_02.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP MASTERMIND REPORT SERVER 01
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_mastermind_rs_01" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_mastermind_rs_01.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP MASTERMIND REPORT SERVER 02
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_mastermind_rs_02" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_mastermind_rs_02.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP NAS 01
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_nas_01" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_nas_01.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP CLIMAX 01
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_climax_01" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_linux_virtual_machine.vm_chl_climax_01.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP CLIMAX 02
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_climax_02" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_linux_virtual_machine.vm_chl_climax_02.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP NEO DLS 01
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_dls5_01" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_dls5_01.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP RSI A
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_rsia" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_rsia.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP RSI B
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_rsib" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_rsib.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP RSI TMT
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_tmta" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_tmta.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP SIGNAL PROCESSOR 01
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_signal_processor_01" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_signal_processor_01.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP SIGNAL PROCESSOR 02
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_signal_processor_02" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_signal_processor_02.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}

##########################################################################
######## BACKUP SIGNAL PROCESSOR 03
##########################################################################
resource "azurerm_backup_protected_vm" "vm_chl_signal_processor_03" {
  resource_group_name = azurerm_recovery_services_vault.recovery_services_vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recovery_services_vault.name
  source_vm_id        = azurerm_windows_virtual_machine.vm_chl_signal_processor_03.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy_production.id
}