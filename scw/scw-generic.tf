terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.0.0-rc1"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  access_key = var.scw_accesskey
  secret_key = var.scw_secretkey
  region     = var.scw_region
  zone       = var.scw_zone
}

resource "random_string" "scw-random" {
  length  = 5
  upper   = false
  special = false
}

variable "scw_accesskey" {
  type = string
}

variable "scw_secretkey" {
  type = string
}

variable "scw_region" {
  type = string
}

variable "scw_zone" {
  type = string
}

variable "ssh_key" {
  type        = string
  description = "The public SSH key for access to the instance"
}

variable "mgmt_cidr" {
  type        = string
  description = "The subnet in CIDR notation able to reach the instance via SSH, HTTPS, and (if dns_novpn = 1) DNS."
}

variable "scw_cidr" {
  type        = string
  description = "The subnet in CIDR notation created within the project."
}

variable "client_cidrs" {
  type        = list(any)
  description = "List of subnets (in CIDR notation) granted access to DNS without VPN"
  default     = []
}

variable "vpn_cidr" {
  type        = string
  description = "The subnet in CIDR notation able to reach the instance via Wireguard VPN."
}

variable "ph_password" {
  type        = string
  description = "pihole webui password"
}

variable "project_url" {
  type        = string
  description = "The github project URL of the playbook to run."
}

variable "scw_image" {
  type        = string
  description = "DO image name."
}

variable "scw_size" {
  type        = string
  description = "instance size/type"
}

variable "scw_prefix" {
  type        = string
  description = "A (short) friendly prefix, applied to most name labels."
}

variable "docker_network" {
  type        = string
  description = "docker network ip"
}

variable "docker_gw" {
  type        = string
  description = "docker network gateway ip"
}

variable "docker_doh" {
  type        = string
  description = "cloudflared_doh container ip"
}

variable "docker_pihole" {
  type        = string
  description = "pihole container ip"
}

variable "docker_wireguard" {
  type        = string
  description = "wireguard container ip"
}

variable "docker_webproxy" {
  type        = string
  description = "https web proxy container ip"
}

variable "wireguard_network" {
  type        = string
  description = "wireguard vpn network ip"
}

variable "wireguard_peers" {
  type        = number
  description = "number of peers to generate for wireguard"
}

variable "doh_provider" {
  type        = string
  description = "DNS over HTTPS provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended"
}

variable "vpn_traffic" {
  type        = string
  description = "dns or all, sets the Wireguard VPN client configuration to route only dns traffic or all traffic through the VPN."
}

variable "dns_novpn" {
  type        = number
  description = "Enable (1) or disable (0) exposuring of port 53 (tcp and udp), DNS via pihole, to mgmt_cidr"
}

# IPv4 address for the machine executing the TF code

data "http" "execution_ip" {
  url = "http://ipv4.icanhazip.com"
}