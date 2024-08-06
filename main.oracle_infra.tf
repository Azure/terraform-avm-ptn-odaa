




// OperationId: CloudExadataInfrastructures_CreateOrUpdate, CloudExadataInfrastructures_Get, CloudExadataInfrastructures_Delete
// PUT /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudExadataInfrastructures/{cloudexadatainfrastructurename}
resource "azapi_resource" "odaa_infra" {
  for_each = var.cloud_exadata_infrastructure

  type      = "Oracle.Database/cloudExadataInfrastructures@2023-09-01-preview"
  parent_id = data.azurerm_resource_group.rg.id
  name      = each.value.name

  timeouts {
    create = "1h30m"
    delete = "20m"
  }

  body = {
    "location" : var.location,
    "zones" : [
      each.value.zone
    ],
    "tags" : {
      "createdby" : each.value.createdby
    },
    "properties" : {
      "computeCount" : each.value.compute_count,
      "displayName" : each.value.display_name,
      "maintenanceWindow" : {
        "leadTimeInWeeks" : each.value.maintenance_window_leadtime_in_weeks,
        "preference" : each.value.maintenance_window_preference,
        "patchingMode" : each.value.maintenance_window_patching_mode
      },
      "shape" : each.value.shape,
      "storageCount" : each.value.storage_count,
    }
  }
  schema_validation_enabled = false

  depends_on = [ data.azurerm_resource_group.rg ]
}


// OperationId: DbServers_ListByCloudExadataInfrastructure
// GET /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudExadataInfrastructures/{cloudexadatainfrastructurename}/dbServers
# data "azapi_resource_list" "listDbServersByCloudExadataInfrastructure" {
#   for_each = var.cloud_exadata_infrastructure

#   type                   = "Oracle.Database/cloudExadataInfrastructures/dbServers@2023-09-01-preview"
#   parent_id              = azapi_resource.odaa_infra.id
#   depends_on             = [azapi_resource.odaa_infra]
#   response_export_values = ["*"]
# }

data "azapi_resource" "odaa_infra" {
  for_each = azapi_resource.odaa_infra

  type      = "Oracle.Database/cloudExadataInfrastructures@2023-09-01-preview"
  parent_id = data.azurerm_resource_group.rg.id
  name      = each.value.name
}

