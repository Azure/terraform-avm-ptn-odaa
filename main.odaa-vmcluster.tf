# Create Oracle VM Cluster resource

module "odaa_vmcluster" {
  depends_on = [module.odaa_infrastructure]

  for_each = var.cloud_exadata_vm_cluster
  source   = "github.com/sihbher/avm-res-oracle-database-cloudvmcluster"

  # Configure the Cloud Infrastructure resource for the cluster
  cloud_exadata_infrastructure_id = module.odaa_infrastructure[each.value.cloud_exadata_infra_name].resource.id

  # Fundamentals
  cluster_name      = each.value.cluster_name
  location          = each.value.location
  display_name      = each.value.display_name
  hostname          = each.value.hostname
  resource_group_id = data.azurerm_resource_group.odaa_group.id
  ssh_public_keys   = each.value.ssh_public_keys

  # Virtual network settings
  vnet_id            = module.odaa_vnets[each.value.vnet_name].virtual_network_id
  subnet_id          = module.odaa_vnets[each.value.vnet_name].subnets[each.value.client_subnet_name].id
  backup_subnet_cidr = each.value.backup_subnet_cidr

  # Compute configuration settings
  cpu_core_count     = each.value.cpu_core_count
  memory_size_in_gbs = each.value.memory_size_in_gbs

  # Storage configuration
  data_storage_percentage    = each.value.data_storage_percentage
  data_storage_size_in_tbs   = each.value.data_storage_size_in_tbs
  dbnode_storage_size_in_gbs = each.value.dbnode_storage_size_in_gbs

  # Optional settings
  gi_version                   = each.value.gi_version
  is_diagnostic_events_enabled = each.value.is_diagnostic_events_enabled
  is_health_monitoring_enabled = each.value.is_health_monitoring_enabled
  is_incident_logs_enabled     = each.value.is_incident_logs_enabled
  is_local_backup_enabled      = each.value.is_local_backup_enabled
  is_sparse_diskgroup_enabled  = each.value.is_sparse_diskgroup_enabled
  license_model                = each.value.license_model
  nsg_cidrs                    = each.value.nsg_cidrs
  time_zone                    = each.value.time_zone
  tags                         = each.value.tags

}
