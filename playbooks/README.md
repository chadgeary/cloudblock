# Local Deployment
`cloudblock_amd64.yml`, `cloudblock_arm64.yml`, and `cloudblock_raspbian.yml` support standalone deployments.

# Ubuntu Deployment
- Ubuntu 18.04+
- Ansible 2.9+ (python3-based) installed
```
# Clone and change to playbooks directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/playbooks/

# Set Variables
doh_provider=opendns
dns_novpn=1
wireguard_peers=10
vpn_traffic=dns
docker_network=172.18.0.0
docker_gw=172.18.0.1
docker_doh=172.18.0.2
docker_pihole=172.18.0.3
docker_wireguard=172.18.0.4
docker_webproxy=172.18.0.5
wireguard_network=172.19.0.0

# Want to set your own pihole password instead of something randomly generated?
sudo mkdir -p /opt/pihole
echo "somepassword" | sudo tee /opt/pihole/ph_password
sudo chmod 600 /opt/pihole/ph_password

# Execute playbook via ansible - either _amd64 or _arm64 
ansible-playbook cloudblock_amd64.yml --extra-vars="doh_provider=$doh_provider dns_novpn=$dns_novpn wireguard_peers=$wireguard_peers vpn_traffic=$vpn_traffic docker_network=$docker_network docker_gw=$docker_gw docker_doh=$docker_doh docker_pihole=$docker_pihole docker_wireguard=$docker_wireguard docker_webproxy=$docker_webproxy wireguard_network=$wireguard_network"

# See Playbook Summary output for Pihole WebUI URL and Wireguard Client files
```

# Raspbian Deployment
- Raspbian 10 (Buster)
- Tested with Raspberry Pi 4 and 3
```
# Ansible + Git
sudo apt update && sudo apt -y upgrade
sudo apt install git python3-pip
pip3 install --user --upgrade ansible

# Add .local/bin to $PATH
echo PATH="\$PATH:~/.local/bin" >> .bashrc
source ~/.bashrc

# Install the community ansible collection
ansible-galaxy collection install community.general

# Optionally, reboot the raspberry pi
# This may be required if the system was months out date before installing updates!
sudo reboot

# Clone the cloudblock project and change to playbooks directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/playbooks/

# Set Variables
doh_provider=opendns
dns_novpn=1
wireguard_peers=10
vpn_traffic=dns
docker_network=172.18.0.0
docker_gw=172.18.0.1
docker_doh=172.18.0.2
docker_pihole=172.18.0.3
docker_wireguard=172.18.0.4
docker_webproxy=172.18.0.5
wireguard_network=172.19.0.0

# Optional (e.g. your DDNS hostname)
wireguard_hostname=example.com

# Want to set your own pihole password instead of something randomly generated?
sudo mkdir -p /opt/pihole
echo "somepassword" | sudo tee /opt/pihole/ph_password
sudo chmod 600 /opt/pihole/ph_password

# Execute playbook via ansible
ansible-playbook cloudblock_raspbian.yml --extra-vars="doh_provider=$doh_provider dns_novpn=$dns_novpn wireguard_peers=$wireguard_peers vpn_traffic=$vpn_traffic docker_network=$docker_network docker_gw=$docker_gw docker_doh=$docker_doh docker_pihole=$docker_pihole docker_wireguard=$docker_wireguard docker_webproxy=$docker_webproxy wireguard_network=$wireguard_network wireguard_hostname=$wireguard_hostname"

# See Playbook Summary output for Pihole WebUI URL and Wireguard Client files
```

# Variables
```
# doh_provider
The upstream DNS provider reached via DNS over HTTPS. See https://github.com/curl/curl/wiki/DNS-over-HTTPS
One of: adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns pi-dns quad9-recommended

# dns_novpn
Flag to allow DNS lookups directly to the pihole service without Wireguard VPN (exposes Pihole 53/tcp and 53/udp). Useful for local deployments where a traditional DNS service is required.
1 for true, 0 for false

# wireguard_peers
The number of peer creations to generate - one per wireguard-connected device. Generate more than you initially need (there's no harm).

# Generate wireguard client configurations to route only "dns" traffic through VPN, or:
# "peers" - dns + other connected peers
# "all" - all traffic
# The wireguard server container does NOT restrict clients, clients can change their AllowedIPs as desired.
# either "dns" "peers" or "all"
vpn_traffic = "dns"

# others
The IP address variables should be changed if they'll conflict/overlap local networks. wireguard_network must not be in the same /24 as docker_<var>s
```

# Remote Wireguard Connectivity / Port Forwarding
Port 51820 UDP must be open/forwarded to this host.

# FAQs
- Want to reach the PiHole webUI while away?
  - Connect to the Wireguard VPN and browse to Pihole VPN IP in the terraform output ( by default, its https://172.18.0.5/admin/ - for older installations its http://172.18.0.3/admin/ ).

- Public IP address changed?
  - Edit your Wireguard client's `Endpoint` value.

- Raspberry Pi using DHCP and receiving the Pihole DNS (creating a non-working loop)?
  - Set the Raspberry Pi to a hardcoded DNS server.
```
# If the Raspberry Pi's DHCP server points to the Pihole container, ensure the Raspberry Pi's host DNS is not set via DHCP, e.g.:
# backup DHCP client conf
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.$(date +%F_%T)

# Disable DNS via DHCP
sudo sed -i 's/option domain_name_servers, domain_name, domain_search, host_name/option domain_name, domain_search, host_name/' /etc/dhcpcd.conf

# Set a hardcoded DNS server IP - replace 1.1.1.1 with your choice of DNS.
sudo sed -i '0,/#static domain_name_servers=.*/s//static domain_name_servers=1.1.1.1/' /etc/dhcpcd.conf

# if Raspberry Pi is wireless, disconnect/reconnect link
sudo bash -c 'ip link set wlan0 down && ip link set wlan0 up' &

# if Raspberry Pi is wired, disconnect/reconnect link
sudo bash -c 'ip link set eth0 down && ip link set eth0 up' &
```

- How do I update my docker containers?
  - Review [Pihole](https://github.com/pi-hole/docker-pi-hole#upgrading-persistence-and-customizations) and [Wireguard](https://github.com/linuxserver/docker-wireguard) container update instructions.
  - Cloudblock follows these instructions. Be sure cloudblock is locally up-to-date to display the instructions.

```
# Be in the cloudblock/playbooks directory
cd ~/cloudblock/playbooks

# Pull cloudblock code updates
git pull

# Set customized variables
doh_provider=opendns
dns_novpn=1
wireguard_peers=10
vpn_traffic=dns
docker_network=172.18.0.0
docker_gw=172.18.0.1
docker_doh=172.18.0.2
docker_pihole=172.18.0.3
docker_wireguard=172.18.0.4
docker_webproxy=172.18.0.5
wireguard_network=172.19.0.0

# Remove old containers (service is down until Ansible completes)
sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

# Rerun ansible-playbook
ansible-playbook cloudblock_raspbian.yml --extra-vars="doh_provider=$doh_provider dns_novpn=$dns_novpn wireguard_peers=$wireguard_peers vpn_traffic=$vpn_traffic docker_network=$docker_network docker_gw=$docker_gw docker_doh=$docker_doh docker_pihole=$docker_pihole docker_wireguard=$docker_wireguard docker_webproxy=$docker_webproxy wireguard_network=$wireguard_network"
```

# Discussion
[Discord Room](https://discord.gg/zmu6GVnPnj)
