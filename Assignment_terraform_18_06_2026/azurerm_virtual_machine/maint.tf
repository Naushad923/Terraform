resource "azurerm_resource_group" "rg" {
  for_each = var.vm
  name     = each.value.rg1.name
  location = each.value.rg1.location
}
resource "azurerm_virtual_network" "vnt" {
  for_each            = var.vm
  name                = each.value.vnet1.name
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  address_space       = each.value.vnet1.address_space
}
resource "azurerm_subnet" "sb" {
  for_each             = var.vm
  name                 = each.value.sub1.name
  resource_group_name  = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnt[each.key].name
  address_prefixes     = each.value.sub1.address_prefixes
}
resource "azurerm_public_ip" "pip" {
  for_each            = var.vm
  name                = each.value.publicip1.name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  allocation_method   = each.value.publicip1.allocation_method
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vm
  name                = each.value.nic1.name
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  ip_configuration {
    name                          = each.value.nic1.ip_configuration.name
    subnet_id                     = azurerm_subnet.sb[each.key].id
    private_ip_address_allocation = each.value.nic1.ip_configuration.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}
resource "azurerm_linux_virtual_machine" "vmm" {

  for_each              = var.vm
  name                  = each.value.machine.name
  location              = azurerm_resource_group.rg[each.key].location
  resource_group_name   = azurerm_resource_group.rg[each.key].name
  size                  = each.value.machine.size
  admin_username        = each.value.machine.admin_username
  admin_password        = each.value.machine.admin_password
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  disable_password_authentication = false


  os_disk {
    caching              = each.value.machine.os_disk.caching
    storage_account_type = each.value.machine.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.machine.source_image_reference.publisher
    offer     = each.value.machine.source_image_reference.offer
    sku       = each.value.machine.source_image_reference.sku
    version   = each.value.machine.source_image_reference.version
  }
}

