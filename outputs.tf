# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "odaa_vnets" {
  description = "These are the VNets created by the module"
  value       = module.odaa_vnets
}
