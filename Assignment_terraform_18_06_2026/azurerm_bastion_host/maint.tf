resource "azurerm_bastion_host" "bshost" {
    for_each = var.bastion
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  location = each.value.location

  ip_configuration {
    name = each.value.ip_configuration.name
    subnet_id = each.value.ip_configuration.subnet_id
    public_ip_address_id = each.value.ip_configuration.public_ip_address_id
  }
  
}