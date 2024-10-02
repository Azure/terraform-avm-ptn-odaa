<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.71)

## Resources

The following resources are used by this module:

- [azurerm_virtual_network.vnet_destination](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)
- [azurerm_virtual_network.vnet_source](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_primary_vnet_name"></a> [primary\_vnet\_name](#input\_primary\_vnet\_name)

Description: Name of the source vnet

Type: `string`

### <a name="input_primary_vnet_resource_group"></a> [primary\_vnet\_resource\_group](#input\_primary\_vnet\_resource\_group)

Description: Name of the resource group of source vnet

Type: `string`

### <a name="input_secondary_vnet_name"></a> [secondary\_vnet\_name](#input\_secondary\_vnet\_name)

Description: Name of the destination vnet

Type: `string`

### <a name="input_secondary_vnet_resource_group"></a> [secondary\_vnet\_resource\_group](#input\_secondary\_vnet\_resource\_group)

Description: Name of the resource group of destination vnet

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Resource ID of the first peering resource

## Modules

The following Modules are called:

### <a name="module_peering"></a> [peering](#module\_peering)

Source: Azure/avm-res-network-virtualnetwork/azurerm//modules/peering

Version: ~> 0.4.0

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->