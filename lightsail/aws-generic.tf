resource "random_string" "ph-random" {
  length  = 5
  upper   = false
  special = false
}

variable "aws_region" {
  type = string
}

variable "aws_az" {
  type    = number
  default = 0
}

variable "aws_profile" {
  type = string
}

variable "mgmt_cidr" {
  type        = string
  description = "Subnet CIDR allowed to access WebUI and SSH, e.g. <home ip address>/32"
}

variable "client_cidrs" {
  type        = list(any)
  description = "List of subnets (in CIDR notation) granted access to DNS without VPN"
  default     = []
}

variable "vpn_cidr" {
  type        = string
  description = "Subnet CIDR allowed to access the VPN, e.g. 0.0.0.0/0 for world access (enrollment still required)"
}

variable "dns_novpn" {
  type        = number
  description = "1 permits mgmt_cidr access to pihole DNS without VPN."
}

variable "bundle_id" {
  type        = string
  description = "The type of lightsail instance to deploy"
}

variable "blueprint_id" {
  type        = string
  description = "The OS of lightsail instance to deploy"
}

variable "instance_key" {
  type        = string
  description = "A public key for SSH access to instance(s)"
}

variable "name_prefix" {
  type        = string
  description = "A friendly name prefix for the AMI and EC2 instances, e.g. 'ph' or 'dev'"
}

variable "pihole_password" {
  type        = string
  description = "Password to access the Pihole web console"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# region azs
data "aws_availability_zones" "ph-azs" {
  state = "available"
}

# account id
data "aws_caller_identity" "ph-aws-account" {
}

variable "kms_manager" {
  type        = string
  description = "An IAM user for management of KMS key"
}

# kms cmk manager - granted access to KMS CMKs
data "aws_iam_user" "ph-kmsmanager" {
  user_name = var.kms_manager
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

# IPv4 address for the machine executing the TF code

data "http" "execution_ip" {
  url = "http://ipv4.icanhazip.com"
}