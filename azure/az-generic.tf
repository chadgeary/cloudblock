provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "ph-client-conf" {
}

data "azurerm_subscription" "ph-subscription" {
}

resource "random_string" "ph-random" {
  length                  = 5
  upper                   = false
  special                 = false
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

variable "ph_prefix" {
  type                     = string
  description              = "Friendly prefix string affixed to resource names, like storage buckets and instance(s). Can only consist of lowercase letters and numbers, and must less than 19 characters."
}

variable "ssh_user" {
  type                     = string
  description              = "User for access to the virtual machine instance, e.g. ubuntu"
}

variable "ssh_key" {
  type                     = string
  description              = "Public SSH key to access the virtual machine instance"
}

variable "mgmt_cidr" {
  type                     = string
  description              = "A subnet (in CIDR notation) granted SSH, WebUI, and (if dns_novpn = 1) DNS access to virtual machine instance. Deploying from home? This is your public ip with a /32, e.g. 1.2.3.4/32"
}

variable "client_cidrs" {
  type                     = list
  description              = "List of subnets (in CIDR notation) granted access to DNS without VPN"
  default                  = []
}

variable "ph_password" {
  type                     = string
  description              = "Password for Pihole WebUI access"
}

variable "dns_novpn" {
  type                     = number
  description              = "Flag to enable (1) or disable (0) mgmt_cidr's access to direct DNS lookups"
}

variable "project_url" {
  type                     = string
  description              = "URL of the git project"
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

variable "docker_webproxy" {
  type                     = string
  description              = "https web proxy container ip"
}

variable "wireguard_network" {
  type                     = string
  description              = "wireguard vpn network ip"
}

variable "wireguard_peers" {
  type                     = number
  description              = "number of peers to generate for wireguard"
}

variable "doh_provider" {
  type                     = string
  description              = "DNS over HTTPS provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended"
}

variable "vpn_traffic" {
  type                     = string
  description              = "dns or all, sets the Wireguard VPN client configuration to route only dns traffic or all traffic through the VPN."
}
