## COMMON ##
gcp_region = "us-east1"
gcp_zone = "b"
gcp_machine_type = "f1-micro"
gcp_billing_account = "X1X1X1-ABABAB-123456"
gcp_user = "me@example.com"
ph_prefix = "pihole"
ph_password = "changeme"
ssh_key = "ssh-rsa AAAAB3DaaC1yc2EAAAADAQABAAABAQCNreplace_me_replace_me_replace_meoOFKlTiaI7Uaqkc+YzmVw/fy1iFxDDeaZfoc0vuQvPr+LsxUL5UY4ko4tynCSp7zgVpot/OppqdHl5J+DYhNubm8ess6cugTustUZoDmJdo2ANQENeBUNkBPXUnMO1iulfNb6GnwWJ0Z5TRRLGSu1gya2wMLeo1rBJFcb6ZgVLMVHiKgwBy/svUQreR8R+fpVW+Q4rx6RSAltLROUONn0SF2BvvJUueqxpAIaA2rU4UUU69P"
mgmt_cidr = "1.2.3.4/32"
# Pick a DoH provider, one of: adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns opendns pi-dns quad9-recommended
doh_provider = "opendns"

## UNCOMMON ##
project_url = "https://github.com/chadgeary/pihole"
dns_novpn = 0
vpn_cidr = "0.0.0.0/0"
gcp_project_services = ["serviceusage.googleapis.com","cloudkms.googleapis.com","storage-api.googleapis.com","secretmanager.googleapis.com"]
gcp_image_project = "ubuntu-os-cloud"
gcp_image_name = "ubuntu-1804-bionic-v20200923"
ssh_user = "ubuntu"
gcp_cidr = "10.10.12.0/24"
gcp_instanceip = "10.10.12.5"
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_doh = "172.18.0.2"
docker_pihole = "172.18.0.3"
docker_wireguard = "172.18.0.4"
wireguard_network = "172.19.0.0"
