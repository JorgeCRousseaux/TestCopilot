variable "disks" {
  default = {}
  description = <<disks
  Mapa de mapas con la definicion de los discos de datos
  ```
  disks = {
    disk1 = {
        name = string
        create_option = string
        disk_size_gb = number
        storage_account_type = string
        zone = string
        lun = number
        caching = string
    }
    ...
    diskN = {
        name = string
        create_option = string
        disk_size_gb = number
        storage_account_type = string
        zone = string
        lun = number
        caching = string
    }
  }
  ```
disks
}
variable "linux" {
  nullable = true
  default = null
  description = <<linux
  Mapa con la definicion de la maquina virtual de linux. Requerido si no se especifica la variable 'windows'
  ```
  linux = {
    computer_name = string
    disable_password_authentication = bool
    name = string
    size = string
    zone = number
    os_disk = {
        caching = string
        disk_size_gb = number
        name = string
        storage_account_type = string
    }
    source_image_reference {
        offer     = string
        sku       = string
        version   = string
        publisher = string
    }
  }
  ```
linux
}
variable "location" {
  description = "Zona donde se va a desplegar el recurso"
  type = string
}
variable "nic" {
  description = <<nic
  Mapa con la definicion de la network interface que va a usar la VM
  ```
  nic = {
  name = string
  ip_configuration = {
    name = string
    subnet_id = string
    private_ip_address_allocation = string
  }
  ```
nic
}
variable "resource_group_name" {
  description = "Nombre del grupo de recusros donde se va a desplegar el recurso"
  type = string
}
variable "windows" {
  nullable = true
  default = null
  description = <<windows
  Mapa con la definicion de la maquina virtual de windows. Requerido si no se especifica la variable 'linux'
  ```
  windows = {
    computer_name = string
    enable_automatic_updates = bool
    name = string
    patch_assessment_mode = string
    patch_mode = string
    size = string
    zone = number
    os_disk = {
        caching = string
        disk_size_gb = number
        name = string
        storage_account_type = string
    }
    source_image_reference {
        offer     = string
        sku       = string
        version   = string
        publisher = string
    }
  }
  ```
windows
}
variable "tags" {
  description = "Mapa de tags para añadir"
  default     = {}
}