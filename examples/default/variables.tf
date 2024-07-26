# variable "enable_telemetry" {
#   type        = bool
#   default     = true
#   description = <<DESCRIPTION
# This variable controls whether or not telemetry is enabled for the module.
# For more information see <https://aka.ms/avm/telemetryinfo>.
# If it is set to false, then no telemetry will be collected.
# DESCRIPTION
# }

# variable "location" {
#   type        = string
#   description = "Azure region where the resource should be deployed."
#   nullable    = false
# }

# # This is required for most resource modules
# variable "resource_group_name" {
#   type        = string
#   description = "The resource group where the resources will be deployed."
# }


# ############################################################################################################
# ##################### Cloud Exadata VM Cliuster variables
# ############################################################################################################
# variable "odaa_cluster_name" {
#   type        = string
#   description = "The name of the cluster."
# }
# variable "odaa_cluster_display_name" {
#   type        = string
#   description = "The display name of the cluster."
# }
# variable "odaa_cluster_data_storage_size_in_tbs" {
#   type        = number
#   description = "The data storage size in TBs."
# }
# variable "odaa_cluster_dbnode_storage_size_in_gbs" {
#   type        = number
#   description = "The DB node storage size in GBs."
# }
# variable "odaa_cluster_time_zone" {
#   type        = string
#   description = "The time zone of the cluster."
#   default     = "UTC"
# }
# #Is this the total memory size of the cluster or the amount of memory per VM?
# variable "odaa_cluster_memory_size_in_gbs" {
#   type        = number
#   description = "The memory size in GBs."
# }
# variable "odaa_cluster_hostname" {
#   type        = string
#   description = "The hostname of the cluster."
# }
# variable "odaa_cluster_domain" {
#   type        = string
#   description = "The domain of the cluster."
#   default     = "domain1"
# }
# variable "odaa_cluster_cpu_core_count" {
#   type        = number
#   description = "The CPU core count of the cluster."
# }
# # variable "odaa_cluster_ocpu_count" {
# #   type        = optional(number)
# #   description = "The OCPU count of the cluster."
# # }
# variable "odaa_cluster_data_storage_percentage" {
#   type        = number
#   description = "The data storage percentage of the cluster."
#   default     = 100
#   validation {
#     condition     = var.odaa_cluster_data_storage_percentage >= 0 && var.odaa_cluster_data_storage_percentage <= 100
#     error_message = "The percentage must be a number between 0 and 100."
#   }
# }
# variable "odaa_cluster_is_local_backup_enabled" {
#   type        = bool
#   description = "The local backup enabled status of the cluster."
#   default     = false
# }
# variable "odaa_cluster_is_sparse_diskgroup_enabled" {
#   type        = bool
#   description = "The sparse diskgroup enabled status of the cluster."
#   default     = false
# }
# variable "odaa_cluster_ssh_public_keys" {
#   type        = string
#   description = "The SSH public keys of the cluster."
# }
# variable "odaa_cluster_nsg_cidrs" {
#   type = set(object({
#     source = string
#     destination_port_range = optional(set(object({
#       min = string
#       max = string
#     })), null)
#   }))
#   description = "A set of NSG CIDRs of the cluster."
# }
# variable "odaa_cluster_license_model" {
#   type        = string
#   description = "The license model of the cluster."
#   default     = "LicenseIncluded"
#   validation {
#     condition     = var.odaa_cluster_license_model == "LicenseIncluded" || var.odaa_cluster_license_model == "BringYourOwnLicense"
#     error_message = "The license model must be either 'LicenseIncluded' or 'BringYourOwnLicense'."
#   }
# }
# variable "odaa_cluster_gi_version" {
#   type        = string
#   description = "The GI version of the cluster."
#   default     = "19.0.0.0"
#   validation {
#     condition     = can(regex("^(\\d+\\.){2}\\d+\\.\\d+$", var.odaa_cluster_gi_version))
#     error_message = "The GI version must be in the format 'XX.XX.XX.XX'."
#   }
# }
# variable "odaa_cluster_backup_subnet_cidr" {
#   type        = string
#   description = "The backup subnet CIDR of the cluster."
#   validation {
#     condition     = can(regex("^(\\d+\\.){3}\\d+\\/\\d+$", var.odaa_cluster_backup_subnet_cidr))
#     error_message = "The backup subnet CIDR must be in the format 'XXX.XXX.XXX.XXX/XX'."
#   }
# }
# variable "odaa_cluster_is_diagnostic_events_enabled" {
#   type        = bool
#   description = "The diagnostic events enabled status of the cluster."
#   default     = false
# }
# variable "odaa_cluster_is_health_monitoring_enabled" {
#   type        = bool
#   description = "The health monitoring enabled status of the cluster."
#   default     = false
# }
# variable "odaa_cluster_is_incident_logs_enabled" {
#   type        = bool
#   description = "The incident logs enabled status of the cluster."
#   default     = false
# }
