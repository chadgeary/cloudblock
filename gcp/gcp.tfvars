## COMMON ##
ph_password = "changeme"
ssh_key = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr = "1.2.3.4/32"

gcp_billing_account = "X1X1X1-ABABAB-123456"
gcp_user = "me@example.com"

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
# At the time of this guide, only us-west1, us-central1, and us-east1 are always-free compatible
gcp_region = "us-east1"
gcp_zone = "b"

# Ubuntu occasionally updates the base image, use the following command to see the latest image name
# gcloud compute images list --project ubuntu-os-cloud --filter="family=('ubuntu-1804-lts')" --format="value('NAME')"
gcp_image_name = "ubuntu-1804-bionic-v20201014"
gcp_image_project = "ubuntu-os-cloud"

## VERY UNCOMMON ##
ph_prefix = "cloudblock"
gcp_machine_type = "f1-micro"
project_url = "https://github.com/chadgeary/cloudblock"
gcp_project_services = ["serviceusage.googleapis.com","cloudkms.googleapis.com","storage-api.googleapis.com","secretmanager.googleapis.com"]
vpn_cidr = "0.0.0.0/0"
ssh_user = "ubuntu"
gcp_cidr = "10.10.12.0/24"
gcp_instanceip = "10.10.12.5"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
docker_webproxy = "172.18.0.5"
wireguard_network = "172.19.0.0"
