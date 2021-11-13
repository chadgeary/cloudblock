provider "google" {
  region                   = var.gcp_region
}

variable "gcp_region" {
  type                     = string
}

variable "gcp_zone" {
  type                     = string
  description              = "The letter-code for a region's zone, e.g. b in us-east1-b"
}

variable "gcp_user" {
  type                     = string
}

variable "ssh_user" {
  type                     = string
  description              = "The user to associate with the SSH key. Default: ubuntu"
}

variable "ssh_key" {
  type                     = string
  description              = "A public SSH key to associate with var.ssh_user, for SSH access to the instance."
}

variable "mgmt_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation able to reach the instance via SSH, HTTPS, and (if dns_novpn = 1) DNS."
}

variable "client_cidrs" {
  type                     = list
  description              = "List of subnets (in CIDR notation) granted access to DNS without VPN"
  default                  = []
}

variable "vpn_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation able to reach the instance via Wireguard VPN."
}

variable "gcp_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation created within the GCP project."
}

variable "gcp_instanceip" {
  type                     = string
  description              = "An IP within the gcp_cidr subnet for the GCP instance."
}

variable "dns_novpn" {
  type                     = number
  description              = "Enable (1) or disable (0) exposuring of port 53 (tcp and udp), DNS via pihole, to mgmt_cidr"
}

variable "ph_password" {
  type                     = string
  description              = "Password for access to the pihole Web UI."
}

variable "project_url" {
  type                     = string
  description              = "The github project URL of the playbook to run."
}

variable "gcp_billing_account" {
  type                     = string
  description              = "The GCP billing account ID"
}

variable "gcp_project_services" {
  type                     = list(string)
  description              = "The service APIs to enable under the project"
}

variable "gcp_image_project" {
  type                     = string
  description              = "Project name where the image resides."
}

variable "gcp_image_name" {
  type                     = string
  description              = "The name of the Ubuntu (18.04 tested) image."
}

variable "gcp_machine_type" {
  type                     = string
  description              = "Instance size/type"
}

variable "ph_prefix" {
  type                     = string
  description              = "A (short) friendly prefix, applied to most name labels."
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
