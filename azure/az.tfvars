## COMMON ##
az_region = "East US"
az_zone = "2"
ph_password = "changeme"
mgmt_cidr = "1.2.3.4/32"
ssh_key = "ssh-rsa AAAAchangeme_changeme_changeme_changemexUL5UY4ko4tynCSp7zgVpot/OppqdHl5J+DYhNubm8ess6cugTustUZoDmJdo2ANQENeBUNkBPXUnMO1iulfNb6GnwWJ0Z5TRRLGSu1gya2wMLeo1rBJFcb6ZgVLMVHiKgwBy/svUQreR8R+fpVW+Q4rx6RSAltLROUONn0SF2BvvJUueqxpAIaA2rU4MSI69P"

# Pick a DoH provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended
doh_provider = "opendns"

# Allow mgmt_cidr to perform DNS queries directly the instance public IP address, without wireguard (1 = true)
dns_novpn = 1

## UNCOMMON ##
# ph_prefix can only consist of lowercase letters and numbers, and should be <10 characters
ph_prefix = "pihole"
az_network_cidr = "10.10.10.0/24"
az_subnet_cidr = "10.10.10.0/26"
az_image_version = "18.04.202010140"
# free tier
az_vm_size = "Standard_B1s"
az_disk_gb = 64
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
wireguard_network = "172.19.0.0"
