module "odaa_vnets" {
  for_each                      = var.virtual_networks
  source                        = "Azure/avm-res-network-virtualnetwork/azurerm"
  version                       = "0.4.0"
  name                          = each.value.name
  location                      = var.location
  address_space = each.value.address_space
  tags                          = var.tags
  diagnostic_settings = var.diagnostic_settings

  subnets = { for idx, item in each.value.subnet :
    "${item.name}" => {
      address_prefixes = item.address_prefixes
      name = item.name
      delegation = item.delegate_to_oracle ? [
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
      ] : []
    }
  }
  resource_group_name = var.resource_group_name

  depends_on = [data.azurerm_resource_group.rg]
}


