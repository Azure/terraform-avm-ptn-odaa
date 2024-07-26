# output "private_endpoints" {
#   description = <<DESCRIPTION
#   A map of the private endpoints created.
#   DESCRIPTION
#   value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
# }

# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "odaa_vnets" {
  description = "This is the full output for the resource."
  value       = module.odaa_vnets
}


output "odaa_infra_instances" {
  value = { for k, v in azapi_resource.odaa_infra : k => v.id }
}
