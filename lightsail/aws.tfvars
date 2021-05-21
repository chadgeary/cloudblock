## COMMON ##
pihole_password = "changeme"
instance_key = "ssh-rsa AAAAB3NzaC1ychange_me_change_me_change_me="

# ip range permitted access to instance SSH and pihole webUI. Also granted DNS access if dns_novpn = 1.
# Deploying for home use? This should be your public IP address/32.
mgmt_cidr = "a.b.c.d/32"

# an AWS IAM account (not root) performing the terraform apply. Granted access to s3 files, etc.
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

# additional client networks granted access pihole DNS without the VPN, example format:
# client_cidrs = ["127.0.0.1/32","8.8.8.8/32"]
client_cidrs = []

# aws lightsail does not support every aws region, see: https://lightsail.aws.amazon.com/ls/docs/en_us/articles/understanding-regions-and-availability-zones-in-amazon-lightsail
aws_region = "us-east-1"

# pick an availability zone, 0 = a, 1 = b, 2 = c, etc.
aws_az = 0

# lightsail uses "bundles and blueprints" instead of instance typesi and AMIs - see: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance#bundles and https://aws.amazon.com/lightsail/pricing/
# attempting to use nano may or may not succeed, good luck!
bundle_id = "micro_2_0"
blueprint_id = "ubuntu_20_04"

# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
name_prefix = "cloudblock"

# Change if ip settings would interfere with existing networks, wireguard network must not be in same /24 as docker_<var>s
vpn_cidr = "0.0.0.0/0"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
docker_webproxy = "172.18.0.5"
wireguard_network = "172.19.0.0"
