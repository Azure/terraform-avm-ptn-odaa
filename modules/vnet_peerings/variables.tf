variable "primary_vnet_name" {
  type        = string
  description = "Name of the source vnet"
}

variable "primary_vnet_resource_group" {
  type        = string
  description = "Name of the resource group of source vnet"
}

variable "secondary_vnet_name" {
  type        = string
  description = "Name of the destination vnet"
}

variable "secondary_vnet_resource_group" {
  type        = string
  description = "Name of the resource group of destination vnet"
}
