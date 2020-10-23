provider "oci" {
}

variable "oci_config_profile" {
  type                     = string
}

variable "oci_root_compartment" {
  type                     = string
}

variable "oci_region" {
  type                     = string
}

variable "vcn_cidr" {
  type                     = string
}

variable "mgmt_cidr" {
  type                     = string
}

variable "ph_prefix" {
  type                     = string
}

variable "dns_novpn" {
  type                     = number
}
