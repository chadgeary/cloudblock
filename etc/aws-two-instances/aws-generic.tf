resource "random_string" "ph-random" {
  length                  = 5
  upper                   = false
  special                 = false
}

variable "aws_region" {
  type                     = string
}

variable "aws_profile" {
  type                     = string
}

variable "vpc_cidr" {
  type                     = string
}

variable "pubnet_cidr" {
  type                     = string
}

variable "pubnet_instance_ip" {
  type                     = string
}

variable "pubnet_instance_ip2" {
  type                     = string
}

variable "mgmt_cidr" {
  type                     = string
  description              = "Subnet CIDR allowed to access WebUI and SSH, e.g. <home ip address>/32"
}

variable "client_cidrs" {
  type                     = list
  description              = "List of subnets (in CIDR notation) granted access to DNS without VPN"
}

variable "vpn_cidr" {
  type                     = string
  description              = "Subnet CIDR allowed to access the VPN, e.g. 0.0.0.0/0 for world access (enrollment still required)"
}

variable "dns_novpn" {
  type                     = number
  description              = "1 permits mgmt_cidr access to pihole DNS without VPN."
}

variable "instance_type" {
  type                     = string
  description              = "The type of EC2 instance to deploy"
}

variable "instance_key" {
  type                     = string
  description              = "A public key for SSH access to instance(s)"
}

variable "instance_vol_size" {
  type                     = number
  description              = "The volume size of the instances' root block device"
}

variable "name_prefix" {
  type                     = string
  description              = "A friendly name prefix for the AMI and EC2 instances, e.g. 'ph' or 'dev'"
}

variable "vendor_ami_account_number" {
  type                     = string
  description              = "The account number of the vendor supplying the base AMI"
}

variable "vendor_ami_name_string" {
  type                     = string
  description              = "The search string for the name of the AMI from the AMI Vendor"
}

variable "pihole_password" {
  type                     = string
  description              = "Password to access the Pihole web console"
}

provider "aws" {
  region                   = var.aws_region
  profile                  = var.aws_profile
}

# region azs
data "aws_availability_zones" "ph-azs" {
  state                    = "available"
}

# account id
data "aws_caller_identity" "ph-aws-account" {
}

variable "kms_manager" {
  type                     = string
  description              = "An IAM user for management of KMS key"
}

# kms cmk manager - granted access to KMS CMKs
data "aws_iam_user" "ph-kmsmanager" {
  user_name               = var.kms_manager
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
