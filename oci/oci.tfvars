## COMMON ##
ph_password = "changeme"
ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCNCHANGE_ME_CHANGE_ME_CHANGE_ME"
mgmt_cidr = "1.2.3.4/32"

oci_config_profile = "/home/chad/.oci/config"
oci_root_compartment = "ocid1.tenancy.oc1..aaaaaaaaCHANGE_ME_CHANGE_ME_CHANGE_ME"

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

# a value of 1 permits mgmt_cidr and client_cidrs access to DNS without the VPN
dns_novpn = 1

# additional client networks granted access pihole DNS without the VPN, example format:
# client_cidrs = ["127.0.0.1/32","8.8.8.8/32"]
client_cidrs = []

## UNCOMMON ##
# If you're using the free-tier, see which region/ad is free-tier compatible run the following two commands and look for value: 2
# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]")
# oci limits value list --compartment-id $OCI_TENANCY_OCID --service-name compute --query "data [?contains(\"name\",'standard-e2-micro-core-count')]" --all
oci_region = "us-ashburn-1"
oci_adnumber = 2
oci_instance_shape = "VM.Standard.E2.1.Micro"

# OCI's managed Ubuntu 18.04 Minimal image, might need to be changed in the future as images are updated periodically
# See https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-1804/
# Find Canonical-Ubuntu-18.04-Minimal, click it then use the OCID of the image in your region
oci_imageid = "ocid1.image.oc1.iad.aaaaaaaascyqvxuxse7kgqtu4go2fazlxqjhq4p4p2rromclajqglaqfyhlq"

## VERY UNCOMMON - Change if git project is cloned or deploying into an existing OCI environment where IP schema might overlap ##
vcn_cidr = "10.10.12.0/24"
ph_prefix = "cloudblock"
project_url = "https://github.com/chadgeary/cloudblock"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
docker_webproxy = "172.18.0.5"
wireguard_network = "172.19.0.0"
