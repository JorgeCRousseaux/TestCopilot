#! ROUTING
#! Especificar un mapa con tablas de ruta para crear
#! Especificar un mapa con reglas para añadir a las tablas (opcional)

#? TABLE
resource "azurerm_route_table" "name" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  # bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  disable_bgp_route_propagation = var.bgp_route_propagation_enabled
  tags                          = var.tags
}

#? ROUTES
#* OPCIONAL
resource "azurerm_route" "name" {
  for_each = var.routes

  address_prefix         = each.value.address_prefix
  name                   = each.value.name
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address,null)
  next_hop_type          = each.value.next_hop_type
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.name.name
}

# #? ASSOCIATION
# #* OPCIONAL
# resource "azurerm_subnet_route_table_association" "name" {
#   for_each = var.routes

#   route_table_id = azurerm_route_table.name[each.key].id
#   subnet_id      = each.value.subnet_id
# }