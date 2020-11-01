# COMMON 
pihole_password = "changeme"
kms_manager = "some_username"
instance_key = "ssh-rsa AAAAB3NzaC1ychange_me_change_me_change_me="

# ip subnet permitted access to instance SSH and pihole webUI. Also granted DNS access if dns_novpn = 1.
# Deploying for home use? This should be your public IP address/32.
mgmt_cidr = "a.b.c.d/32"

# dns over https provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns pi-dns quad9-recommended - see https://github.com/curl/curl/wiki/DNS-over-HTTPS
doh_provider = "opendns"

##
## UNCOMMON / DEFAULTS ##
##

# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
aws_region = "us-east-1"

# ip subnet permitted access to VPN. VPN clients would still require the Wireguard enrollment configuration. 0.0.0.0/0 = open to world.
vpn_cidr = "0.0.0.0/0"

# a value of 1 permits mgmt_cidr access to DNS without the VPN
dns_novpn = 1

# must be ARM-based, t4g.nano is sufficient. t4g.micro is free into Dec 31 2020.
instance_type = "t4g.micro"

# instance (ebs) disk size in GiB, 30 is OK.
instance_vol_size = 30

# a common name prefix for the AMI, instance, ssh key, etc. Useful to change if creating more than one deployment per AWS account to differentiate.
name_prefix = "ph"

# the vendor supplying the AMI and the AMI name - default is official Ubuntu 18.04 ARM - note the date may need to be changed.
# list amis via AWS CLI with:
# aws ec2 describe-images --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-*' 'Name=state,Values=available'
vendor_ami_account_number = "099720109477"
vendor_ami_name_string = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-20200922"

# vpc specific vars - change if would interfere with other VPC resources
vpc_cidr = "10.10.12.0/24"
pubnet_cidr = "10.10.12.0/26"
pubnet_instance_ip = "10.10.12.5"

# docker specific vars - change if would interfere with VPN clients' local networks
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"

# wireguard specific vars - change if would interfere with VPN clients' local networks
wireguard_network = "172.19.0.0"
