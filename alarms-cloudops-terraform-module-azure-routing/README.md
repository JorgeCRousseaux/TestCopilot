# Routing Module

## Introducción

Código de un modulo de terraform para crear una tabla de rutas y añadir tantas rutas como fuese necesario.

## Uso

Un ejemplo de uso de este módulo. Crea una tabla de rutas `my-route-table` y añade dos rutas.

```
#fichero de variables (variables.tfvars)
location = "West Europe"
rt_name = "my-route-table"
rt_bgp = false
rt_routes = {
    route1 = {
      address_prefix         = "10.0.0.0/16"
      name                   = "route1"
      next_hop_in_ip_address = "10.0.0.1"
      next_hop_type          = "VirtualAppliance"
    },
    route2 = {
      address_prefix         = "10.0.1.0/16"
      name                   = "route2"
      next_hop_in_ip_address = "10.0.1.1"
      next_hop_type          = "VirtualAppliance"
    }
  }

#invocación del módulo
module "route_table" {
  source                = "git::https://github.com/prosegur/alarms-cloudops-terraform-module-azure-routing"
  name                  = var.rt_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.example.name
  bgp_route_propagation_enabled = var.rt_bgp
  routes = var.rt_routes
  tags = {
    environment = "production"
    team        = "network"
  }
}

```


## Terraform-docs

Documentación generada automáticamente con terraform-docs
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_route.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bgp_route_propagation_enabled"></a> [bgp\_route\_propagation\_enabled](#input\_bgp\_route\_propagation\_enabled) | Valor booleano para controlar la propagacion con BGP | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Zona donde se va a desplegar el recurso | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Nombre de la tabla de rutas | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Nombre del grupo de recusros donde se va a desplegar el recurso | `any` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Mapa de mapas con las rutas que se van a añadir.<pre>routes = {<br>    ruta1 = {<br>      address_prefix         = string (obligatorio)<br>      name                   = string (obligatorio)<br>      next_hop_in_ip_address = string (opcional)<br>      next_hop_type          = string (obligatorio)<br>    }<br>    ...<br>    rutaN = {<br>      address_prefix         = string (obligatorio)<br>      name                   = string (obligatorio)<br>      next_hop_in_ip_address = string (opcional)<br>      next_hop_type          = string (obligatorio)<br>    }<br>  }</pre> | `map` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Mapa de tags para añadir | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table"></a> [table](#output\_table) | Devuelve el objeto entero de la tabla de ruta, para poder acceder a cualquier elemento si fuese necesario |
<!-- END_TF_DOCS -->