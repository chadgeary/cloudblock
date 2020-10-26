provider "azurerm" {
  features {}
}

variable "az_region" {
  type                     = string
  description              = "Region to deploy services in"
}

variable "az_zone" {
  type                     = string
  description              = "An availability zone in a region, e.g. 1"
}

variable "az_image_version" {
  type                     = string
  description              = "The version of Canonical's Ubuntu 18_04-lts-gen2 azure image"
}

variable "az_vm_size" {
  type                     = string
  description              = "Size of the azure vm instance"
}

variable "az_disk_gb" {
  type                     = number
  description              = "Instance disk size, in gigabytes"
}

variable "az_network_cidr" {
  type                     = string
  description              = "Network (in CIDR notation) for the azure virtual network"
}

variable "az_subnet_cidr" {
  type                     = string
  description              = "Network (in CIDR notation) as a sub-network of the azure virtual network"
}

variable "az_dns1" {
  type                     = string
  description              = "IP address in az_network_cidr assigned to DNS IP 1"
}

variable "az_dns2" {
  type                     = string
  description              = "IP address in az_network_cidr assigned to DNS IP 2"
}

variable "ph_prefix" {
  type                     = string
  description              = "Friendly prefix string affixed to resource names, like storage buckets and instance(s)."
}

variable "ssh_user" {
  type                     = string
  description              = "User for access to the virtual machine instance, e.g. ubuntu"
}

variable "ssh_key" {
  type                     = string
  description              = "Public SSH key to access the virtual machine instance"
}
