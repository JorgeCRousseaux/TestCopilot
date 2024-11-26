//output
output "vm" {
    value = var.windows != null ? azurerm_windows_virtual_machine.name[0] : azurerm_linux_virtual_machine.name[0]
    description = "Devuelve el objeto de la VM de windows o de linux (en funcion de cual se haya creado) para poder acceder a sus argumentos, por ejemplo a ID o name"
    sensitive = false
}

output "nic" {
  value = azurerm_network_interface.name
  description = "Devuelve el objeto de la NIC para poder acceder a sus argumentos como ID o name"
  sensitive = false
}