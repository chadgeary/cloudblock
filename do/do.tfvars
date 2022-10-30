## COMMON ##
ph_password = "changeme1"
ssh_key = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr = "1.2.3.4/32"

# digital ocean specific vars for authentication to DO APIs and Storage
do_token = "changeme3"
do_storageaccessid = "changeme4"
do_storagesecretkey = "changeme5"

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

## UNCOMMON ##
# Note only sfo2, sfo3, nyc3, fra1, and ams3 currently support object storage
# See: https://cloud.digitalocean.com/spaces/new and https://slugs.do-api.dev/
do_region = "nyc3"
do_image = "ubuntu-22-04-x64"

## VERY UNCOMMON ##
do_size = "s-1vcpu-1gb"
do_cidr = "10.10.12.0/24"
do_prefix = "cloudblock"
project_url = "https://github.com/chadgeary/cloudblock"

# Change if ip/port settings would interfere with existing networks, should all be within a /24
vpn_cidr = "0.0.0.0/0"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
docker_webproxy = "172.18.0.5"
wireguard_network = "172.19.0.0"
