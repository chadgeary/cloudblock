## COMMON ##
ph_password = "changeme"
ssh_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCNCHANGE_ME_CHANGE_ME_CHANGE_ME"
mgmt_cidr   = "1.2.3.4/32"

oci_config_profile   = "/home/chad/.oci/config"
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

## FREE TIER USERS ##
# Oracle configured your account for two free virtual machines in a specific cloud REGION + AD (Availability Domain), terraform needs to know these.
# See which REGION + AD oracle assigned to your account with the following two commands (without the #):

# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]")
# oci limits value list --compartment-id $OCI_TENANCY_OCID --service-name compute --query "data [?contains(\"name\",'standard-e2-micro-core-count')]" --all

# Example output - look at each "value" and find the 2 (thats the two free virtual machines)
# The AD number is the last digit in "availability-domain" - 2 in this example (note - some regions only have one AD)
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-1",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 0
#  },
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-2",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 2
#  }

oci_region   = "us-ashburn-1"
oci_adnumber = 1

# By default Cloudblock for OCI is configured to use the Always Free tier included Micro (AMD) instance - a different shape can be specified here
# Always Free VM.Standard.E2.1.Micro up to 1 OCPU and 1 MemGB
# Always Free VM.Standard.A1.Flex up to 4 OCPU and 24 MemGB but OnlyOffice is not compatible
# For ARM, use VM.Standard.A1.Flex
oci_instance_shape = "VM.Standard.E2.1.Micro"

# Default OCPUs and Memory set Always Free tier included Micro instance - can be adjusted here if other shape specified above
oci_instance_ocpus = 1
oci_instance_memgb = 1

# If required, the instance boot volume can be changed here. By default the "VM.Standard.E2.1.Micro" instance uses a 50GB boot volume
# The Always Free tier includes 200GB of block volume storage across all instances in your tenancy
oci_instance_diskgb = 50

# Use a recent version of OCI's managed Ubuntu 22.04 image - specific to your region.
# For the latest Ubuntu 22.04 image ids in your region, run:
# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]") && oci compute image list --compartment-id $OCI_TENANCY_OCID --all --lifecycle-state 'AVAILABLE' --operating-system "Canonical Ubuntu" --operating-system-version "22.04" --sort-by "TIMECREATED" | grep 'display-name\|ocid'

# For ARM instances, choose the AARCH64 ocid in the command above
oci_imageid = "ocid1.image.oc1.iad.aaaaaaaas6qul34auoiybzgbd4dw2irxix73hgps622rk6d7oawzlrtpfiwa"

## VERY UNCOMMON - Change if git project is cloned or deploying into an existing OCI environment where IP schema might overlap ##
vcn_cidr          = "10.10.12.0/24"
ph_prefix         = "cloudblock"
project_url       = "https://github.com/chadgeary/cloudblock"
docker_network    = "172.18.0.0"
docker_gw         = "172.18.0.1"
docker_doh        = "172.18.0.2"
docker_pihole     = "172.18.0.3"
docker_wireguard  = "172.18.0.4"
docker_webproxy   = "172.18.0.5"
wireguard_network = "172.19.0.0"
