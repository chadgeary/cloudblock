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

variable "oci_imageid" {
  type                     = string
}

variable "oci_adnumber" {
  type                     = number
}

variable "oci_instance_shape" {
  type                     = string
}

variable "ssh_key" {
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

variable "ph_password" {
  type                     = string
}

variable "dns_novpn" {
  type                     = number
}

variable "project_url" {
  type                     = string
}

variable "docker_network" {
  type                     = string
  description              = "docker network ip"
}

variable "docker_gw" {
  type                     = string
  description              = "docker network gateway ip"
}

variable "docker_doh" {
  type                     = string
  description              = "cloudflared_doh container ip"
}

variable "docker_pihole" {
  type                     = string
  description              = "pihole container ip"
}

variable "docker_wireguard" {
  type                     = string
  description              = "wireguard container ip"
}

variable "wireguard_network" {
  type                     = string
  description              = "wireguard vpn network ip"
}

variable "doh_provider" {
  type                     = string
  description              = "DNS over HTTPS provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended"
}
