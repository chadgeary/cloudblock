## COMMON ##
ph_password = "changeme"
ssh_key = "ssh-rsa AAAAchangeme_changeme_changeme_changemexUL5UY4ko4tynCSp7zgVpot/OppqdHl5J+DYhNubm8ess6cugTustUZoDmJdo2ANQENeBUNkBPXUnMO1iulfNb6GnwWJ0Z5TRRLGSu1gya2wMLeo1rBJFcb6ZgVLMVHiKgwBy/svUQreR8R+fpVW+Q4rx6RSAltLROUONn0SF2BvvJUueqxpAIaA2rU4MSI69P"
mgmt_cidr = "1.2.3.4/32"

# The number of wireguard peer configurations to generate / store - 1 per device
wireguard_peers = 20

# dns over https provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns pi-dns quad9-recommended - see https://github.com/curl/curl/wiki/DNS-over-HTTPS
doh_provider = "opendns"

# Generate wireguard client configurations to route only "dns" traffic through VPN, or:
# # "peers" - dns + other connected peers
# # "all" - all traffic
# # The wireguard server container does NOT restrict clients, clients can change their AllowedIPs as desired.
# # either "dns" "peers" or "all"
vpn_traffic = "dns"

# a value of 1 permits mgmt_cidr access to DNS without the VPN
dns_novpn = 1

# additional client networks granted access pihole DNS without the VPN, example format:
# client_cidrs = ["127.0.0.1/32","8.8.8.8/32"]
client_cidrs = []

## UNCOMMON ##
# An azure region (and zone), use the following command for a list of region names (use the varsfile value):
# az account list-locations --query "[?metadata.regionType=='Physical'].{varsfile:displayName, cli:name}" --output table
az_region = "East US"
az_zone = "1"

# The version of Ubuntu 1804 to use, use the following command to see the latest official version (replace centralus with the previous command's cli column name
# az vm image show --location "centralus" --urn Canonical:UbuntuServer:18.04-LTS:latest --query name --output table
az_image_version = "18.04.202010140"

# free tier
az_vm_size = "Standard_B1s"
az_disk_gb = 64
# ph_prefix can only consist of lowercase letters and numbers, and should be <=10 characters
ph_prefix = "cloudblock"
az_network_cidr = "10.10.10.0/24"
az_subnet_cidr = "10.10.10.0/26"
ssh_user = "ubuntu"

## VERY UNCOMMON ##
# Change if using a cloned / separate git project or ip settings would interfere with existing networks
project_url = "https://github.com/chadgeary/cloudblock"

# Change if ip settings would interfere with existing networks, wireguard network must not be in same /24 as docker_<var>s
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
docker_webproxy = "172.18.0.5"
wireguard_network = "172.19.0.0"
