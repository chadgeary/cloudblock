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

variable "mgmt_cidr" {
  type                     = string
  description              = "Subnet CIDR allowed to access WebUI and SSH, e.g. <home ip address>/32"
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

variable "bucket_name" {
  type                     = string
  description              = "A unique bucket name to store playbooks and output of SSM"
}

variable "ec2_name_prefix" {
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

variable "ssm_install_dir" {
  type                     = string
  description              = "The directory of the pihole configuration, default is /opt/pihole"
}

variable "ssm_dns_server_1" {
  type                     = string
  description              = "The first (of two) DNS servers the PiHole will query upstream"
}

variable "ssm_dns_server_2" {
  type                     = string
  description              = "The second (of two) DNS servers the PiHole will query upstream"
}

variable "ssm_web_password" {
  type                     = string
  description              = "Password to access the web console"
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
