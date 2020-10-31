## COMMON ##
oci_config_profile = "/home/chad/.oci/config"
oci_root_compartment = "ocid1.tenancy.oc1..aaaaaaaaCHANGE_ME_CHANGE_ME_CHANGE_ME"
ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCNCHANGE_ME_CHANGE_ME_CHANGE_ME"
mgmt_cidr = "1.2.3.4/32"
ph_password = "changeme"

# OCI's managed Ubuntu 18.04 Minimal image, might need to be changed in the future as images are updated periodically
# See https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-1804/
# Find Canonical-Ubuntu-18.04-Minimal, click it then use the OCID of the image in your region
oci_imageid = "ocid1.image.oc1.iad.aaaaaaaaqftrznq64odd4jr3i6bqhccmhs24trdlpmcayg3xnovia3mqspea"

# Pick a DoH provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended
doh_provider = "opendns"

# Allow mgmt_cidr to perform DNS queries directly the instance public IP address, without wireguard (1 = true)
dns_novpn = 1

## UNCOMMON - Free Tier Compatible ##
oci_region = "us-ashburn-1"
oci_adnumber = 2
oci_instance_shape = "VM.Standard.E2.1.Micro"
vcn_cidr = "10.10.12.0/24"
ph_prefix = "pihole"

## VERY UNCOMMON - Change if git project is cloned or deploying into an existing OCI environment where IP schema might overlap ##
project_url = "https://github.com/chadgeary/cloudblock"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
wireguard_network = "172.19.0.0"
