output "resource_id" {
  description = "Resource ID of the first peering resource"
  value       = module.peering.resource_id
}

# output "vnet_peerings_resource_ids" {
#   description = "Resource IDs of the Virtual network peerings created"
#   value       = { for k, v in module.peering : k => v.output.resource_id }
# }
