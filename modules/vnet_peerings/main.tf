data "azurerm_virtual_network" "vnet_source" {
  name                = var.primary-vnet-name
  resource_group_name = var.primary-vnet-resource-group
}

data "azurerm_virtual_network" "vnet_destination" {
  name                = var.secondary-vnet-name
  resource_group_name = var.secondary-vnet-resource-group
}

module "peering" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"

  virtual_network = {
    resource_id = data.azurerm_virtual_network.vnet_source.id
  }
  remote_virtual_network = {
    resource_id = data.azurerm_virtual_network.vnet_destination.id
  }
  name                                 = "${var.primary-vnet-name}-to-${var.secondary-vnet-name}"
  allow_forwarded_traffic              = true
  allow_gateway_transit                = true
  allow_virtual_network_access         = true
  use_remote_gateways                  = false
  create_reverse_peering               = true
  reverse_name                         = "${var.secondary-vnet-name}-to-${var.primary-vnet-name}"
  reverse_allow_forwarded_traffic      = true
  reverse_allow_gateway_transit        = false
  reverse_allow_virtual_network_access = true
  reverse_use_remote_gateways          = false
}
