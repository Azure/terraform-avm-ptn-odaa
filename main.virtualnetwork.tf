module "odaa_vnets" {
  for_each = var.virtual_networks
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.1.4"
  name = each.value.name
  location = var.location
  virtual_network_address_space = each.value.address_space
  tags = var.tags  
  subnets = {for idx, item in each.value.subnet:
    "${item.name}" => {
      address_prefixes = item.address_prefixes
      delegations = item.delegate_to_oracle ? [
        {
          name = item.name
          service_delegation = {
            name = "Oracle.Database/networkAttachments"
            actions = [
              "Microsoft.Network/networkinterfaces/*",
              "Microsoft.Network/virtualNetworks/subnets/join/action"
            ]
          }  
        }
      ]: []
    }
  }
  resource_group_name = var.resource_group_name
  
}


