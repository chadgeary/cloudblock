##
## COMMON / DEPLOYMENT SPECIFIC ##
##

# pihole webUI password
pihole_password = "changeme"

# ip subnet permitted access to instance SSH and pihole webUI. Also granted DNS access if dns_novpn = 1. Deploying for home use? This should be your public IP address/32.
mgmt_cidr = "a.b.c.d/32"

# a unique AWS S3 bucket name - various resources are stored here.
bucket_name = "my-pihole-bucket1"

# the AWS IAM username granted access to the Wireguard VPN files stored in S3.
kms_manager = "some_username"

# A public SSH key for SSH access to the EC2 instance. User ubuntu. Default is a dummy key.
instance_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDD7FLNLu2VPm6SdbQzUyPJMSFbxuOlGzZEa1++sso/Sy5ZYXUAUbBMOt3NS1Jy8RV9tAavdJY7g8J6fPiWogCNdFXoLwcC4e1SAJTh3r3ODAWy8KRgDqcMcb4BXHAOEojCc3z/PhwZeQtTMPrnqAdW+t945B8u0U2d7go8uLTMZVX62occkAwPbyuxf61BEcuoILz9H18ySRtvaEyfiGppfanOy3vAzRazIzVe858flj2FGJggVr4osYsPuVKRyiT7W089oVAhO/1llh+IelPWFfNoD6PQOIWWLu5k/aVC0lxRQibcC/FvJk1f9DGYfu+J+S2bOuC1hq33aXKtWYQtYWPRK+tNsYyyfHJrIs/UvyvHEWOWOXmkKgq069V7bYddJ77ZwEXUhbTJajv7XA4KZuWqqfnueJ17xINZe883M6IgEdF3usijA6h1eecBYGG3gcLQb72hwdlip6wg/ooRMjHvywrfjz9wUhedeB3XBSJqBeUGjN5PSJkoygVdaUs="

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

# dns over https provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended - see https://github.com/curl/curl/wiki/DNS-over-HTTPS
doh_provider = "opendns"

# must be ARM-based, t4g.nano is sufficient. t4g.micro is free into Dec 31 2020.
instance_type = "t4g.micro"

# instance (ebs) disk size in GiB, 30 is OK.
instance_vol_size = 30

# a common name prefix for the AMI, instance, ssh key, etc. Useful to change if creating more than one deployment per AWS account to differentiate.
ec2_name_prefix = "ph"

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
