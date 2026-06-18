resource "azurerm_virtual_network" "vnt" {
for_each = var.vnet
name = each.value.name
location = each.value.location
address_space = each.value.address_space
resource_group_name = each.value.resource_rgoup_name

}