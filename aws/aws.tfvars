## COMMON ##
pihole_password = "changeme"
instance_key = "ssh-rsa AAAAB3NzaC1ychange_me_change_me_change_me="

# ip range permitted access to instance SSH and pihole webUI. Also granted DNS access if dns_novpn = 1.
# Deploying for home use? This should be your public IP address/32.
mgmt_cidr = "a.b.c.d/32"

kms_manager = "some_username"

# The number of wireguard peer configurations to generate / store - 1 per device
wireguard_peers = 20

# dns over https provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns pi-dns quad9-recommended - see https://github.com/curl/curl/wiki/DNS-over-HTTPS
doh_provider = "opendns"

# Generate wireguard client configurations to route only "dns" traffic through VPN, or:
# "peers" - dns + other connected peers
# "all" - all traffic
# The wireguard server container does NOT restrict clients, clients can change their AllowedIPs as desired.
# either "dns" "peers" or "all"
vpn_traffic = "dns"

# a value of 1 permits mgmt_cidr access to DNS without the VPN
dns_novpn = 1

## UNCOMMON ##
aws_region = "us-east-1"

# Must be ARM-based, but not all regions support ARM. Replace us-east-1 with your region, then run the command.
# AWS_REGION=us-east-1 && ~/.local/bin/aws ec2 describe-instance-type-offerings --query "InstanceTypeOfferings[?Location=='$AWS_REGION'] [InstanceType] | sort_by(@, &[0])" --filter Name="instance-type",Values="t4g.*,a1.*" --region $AWS_REGION --output text
instance_type = "t4g.micro"

# The Ubuntu ARM AMI name string, these are occasionally updated with a new date - replace us-east-1 with your region, then run the command:
# AWS_REGION=us-east-1 && ~/.local/bin/aws ec2 describe-images --region $AWS_REGION --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-*' 'Name=state,Values=available' --query 'sort_by(Images, &CreationDate)[-1].Name'
vendor_ami_name_string = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-20200922"
vendor_ami_account_number = "099720109477"

## VERY UNCOMMON ##
# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
instance_vol_size = 30
name_prefix = "cloudblock"
# Change if ip settings would interfere with existing networks, wireguard network must not be in same /24 as docker_<var>s
vpn_cidr = "0.0.0.0/0"
vpc_cidr = "10.10.12.0/24"
pubnet_cidr = "10.10.12.0/26"
pubnet_instance_ip = "10.10.12.5"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
docker_webproxy = "172.18.0.5"
wireguard_network = "172.19.0.0"
