data "azurerm_virtual_network" "vnet_source" {
  name                = var.primary_vnet_name
  resource_group_name = var.primary_vnet_resource_group
}

data "azurerm_virtual_network" "vnet_destination" {
  name                = var.secondary_vnet_name
  resource_group_name = var.secondary_vnet_resource_group
}

module "peering" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/peering"
  version = "~> 0.4.0"
  virtual_network = {
    resource_id = data.azurerm_virtual_network.vnet_source.id
  }
  remote_virtual_network = {
    resource_id = data.azurerm_virtual_network.vnet_destination.id
  }
  name                                 = "${var.primary_vnet_name}-to-${var.secondary_vnet_name}"
  allow_forwarded_traffic              = true
  allow_gateway_transit                = true
  allow_virtual_network_access         = true
  use_remote_gateways                  = false
  create_reverse_peering               = true
  reverse_name                         = "${var.secondary_vnet_name}-to-${var.primary_vnet_name}"
  reverse_allow_forwarded_traffic      = true
  reverse_allow_gateway_transit        = false
  reverse_allow_virtual_network_access = true
  reverse_use_remote_gateways          = false
}
