variable "bgp_route_propagation_enabled" {
  description = "Valor booleano para controlar la propagacion con BGP"
  default     = false
}
variable "location" { description = "Zona donde se va a desplegar el recurso" }
variable "name" { description = "Nombre de la tabla de rutas" }
variable "resource_group_name" { description = "Nombre del grupo de recusros donde se va a desplegar el recurso" }
variable "routes" {
  description = <<ROUTES
  Mapa de mapas con las rutas que se van a añadir.
  ```
  routes = {
    ruta1 = {
      address_prefix         = string (obligatorio)
      name                   = string (obligatorio)
      next_hop_in_ip_address = string (opcional)
      next_hop_type          = string (obligatorio)
    }
    ...
    rutaN = {
      address_prefix         = string (obligatorio)
      name                   = string (obligatorio)
      next_hop_in_ip_address = string (opcional)
      next_hop_type          = string (obligatorio)
    }
  }
  ```
ROUTES
  default     = {}
}
variable "tags" {
  description = "Mapa de tags para añadir"
  default     = {}
}
