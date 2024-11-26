# Virtual Machine Module

## Introducción

Código de un modulo de terraform para crear una máquina virtual, linux o windows, una interfaz de red para la máquina virtual y tantos discos de datos como fuese necesarios.

## Uso

Ejemplo de uso de este módulo para crear una máquina virtual de windows `win-vm` con una nic con IP dinámica.

```hcl
#fichero de variables (variables.tfvars)
location = "West Europe"
windows = {
    name                     = "win-vm"
    enable_automatic_updates = true
    name                     = "windows-vm"
    patch_assessment_mode    = "ImageDefault"
    patch_mode               = "AutomaticByPlatform"
    size                     = "Standard_DS1_v2"
    zone                     = 1
    os_disk = {
      caching              = "ReadWrite"
      disk_size_gb         = 128
      name                 = "windows-os-disk"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
}
nic = {
    name = "windows-nic"
    ip_configuration = {
      name                           = "internal"
      private_ip_address_allocation  = "Dynamic"
    }
}

#invocación del módulo
module "windows_vm" {
  source                = "git::https://github.com/prosegur/alarms-cloudops-terraform-module-azure-vm"
  providers = {
    azurerm.network = azurerm.network
  }
  resource_group_name   = azurerm_resource_group.example.name
  location              = var.location
  windows = var.windows
  nic = var.nic
}
```

Ejemplo de uso de este módulo para crear una máquina virtual de linux `linux-vm` con una nic con IP dinámica y dos discos.

```hcl
#fichero de providers (providers.tf)
provider "azurerm" {
  alias = "network"
  subscription_id = "264007ff-150c-41a3-977e-eeedb46c0c7f"
  features {}
}

#fichero de variables (variables.tfvars)
location = "West Europe"
linux = {
    computer_name                   = "linux-vm"
    disable_password_authentication = true
    name                            = "linux-vm"
    size                            = "Standard_DS1_v2"
    zone                            = 1
    os_disk = {
      caching              = "ReadWrite"
      disk_size_gb         = 128
      name                 = "linux-os-disk"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      offer     = "UbuntuServer"
      publisher = "Canonical"
      sku       = "18.04-LTS"
      version   = "latest"
    }
}
nic = {
    name = "linux-nic"
    ip_configuration = {
      name                           = "internal"
      private_ip_address_allocation  = "Dynamic"
    }
}
disks = {
  disk1 = {
    create_option        = "Empty"
    disk_size_gb         = "10"
    storage_account_type = "Standard_LRS"
    name                 = "acctestmd"
    zone                 = 1
    lun                  = 10
    caching              = "ReadWrite"
  }
  disk2 = {
    create_option        = "Empty"
    disk_size_gb         = "10"
    storage_account_type = "Standard_LRS"
    name                 = "acctestmd2"
    zone                 = 2
    lun                  = 11
    caching              = "ReadWrite"
  }
}


#invocación del módulo
module "linux_vm" {
  source                = "git::https://github.com/prosegur/alarms-cloudops-terraform-module-azure-vm"
  resource_group_name   = azurerm_resource_group.example.name
  location              = var.location
  providers = {
      azurerm.network = azurerm.network
  }
  linux = var.linux
  nic = var.nic
  disks = var.disks
}
```

## Terraform-docs

Documentación generada automáticamente con terraform-docs
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_azurerm.network"></a> [azurerm.network](#provider\_azurerm.network) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_windows_virtual_machine.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azurerm_key_vault.terraform_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.vm_admin_cra_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.vm_admin_cra_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_disks"></a> [disks](#input\_disks) | Mapa de mapas con la definicion de los discos de datos<pre>disks = {<br>    disk1 = {<br>        name = string<br>        create_option = string<br>        disk_size_gb = number<br>        storage_account_type = string<br>        zone = string<br>    }<br>    ...<br>    diskN = {<br>        name = string<br>        create_option = string<br>        disk_size_gb = number<br>        storage_account_type = string<br>        zone = string<br>    }<br>  }</pre> | `map` | `{}` | no |
| <a name="input_linux"></a> [linux](#input\_linux) | Mapa con la definicion de la maquina virtual de linux. Requerido si no se especifica la variable 'windows'<pre>linux = {<br>    computer_name = string<br>    disable_password_authentication = bool<br>    name = string<br>    size = string<br>    zone = number<br>    os_disk = {<br>        caching = string<br>        disk_size_gb = number<br>        name = string<br>        storage_account_type = string<br>    }<br>    source_image_reference {<br>        offer     = string<br>        sku       = string<br>        version   = string<br>        publisher = string<br>    }<br>  }</pre> | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Zona donde se va a desplegar el recurso | `string` | n/a | yes |
| <a name="input_nic"></a> [nic](#input\_nic) | Mapa con la definicion de la network interface que va a usar la VM<pre>nic = {<br>  name = string<br>  ip_configuration = {<br>    name = string<br>    subnet_id = string<br>    private_ip_address_allocation = string<br>  }</pre> | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Nombre del grupo de recusros donde se va a desplegar el recurso | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mapa de tags para añadir | `map` | `{}` | no |
| <a name="input_windows"></a> [windows](#input\_windows) | Mapa con la definicion de la maquina virtual de windows. Requerido si no se especifica la variable 'linux'<pre>windows = {<br>    computer_name = string<br>    enable_automatic_updates = bool<br>    name = string<br>    patch_assessment_mode = string<br>    patch_mode = string<br>    size = string<br>    zone = number<br>    os_disk = {<br>        caching = string<br>        disk_size_gb = number<br>        name = string<br>        storage_account_type = string<br>    }<br>    source_image_reference {<br>        offer     = string<br>        sku       = string<br>        version   = string<br>        publisher = string<br>    }<br>  }</pre> | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nic"></a> [nic](#output\_nic) | Devuelve el objeto de la NIC para poder acceder a sus argumentos como ID o name |
| <a name="output_vm"></a> [vm](#output\_vm) | Devuelve el objeto de la VM de windows o de linux (en funcion de cual se haya creado) para poder acceder a sus argumentos, por ejemplo a ID o name |
<!-- END_TF_DOCS -->