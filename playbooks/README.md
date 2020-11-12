# Local Deployment
`cloudblock_amd64.yml` and `cloudblock_arm64.yml` support standalone deployments.

# Requirements
- Ubuntu 18.04+
- Ansible 2.9+ (python3-based) installed

# Deploy
```
# Clone and change to directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/playbooks/

# Run playbook (target is the localhost)
ansible-playbook cloudblock_amd64.yml --extra-vars 'docker_network=172.18.0.0 docker_gw=172.18.0.1 docker_doh=172.18.0.2 docker_pihole=172.18.0.3 docker_wireguard=172.18.0.4 wireguard_network=172.19.0.0 doh_provider=opendns dns_novpn=1 wireguard_peers=10 vpn_traffic=dns'

# Locate configurations
ls -ltrh /opt/wireguard/peer1/
```

# Variables
```
# doh_provider
The upstream DNS provider reached via DNS over HTTPS. See https://github.com/curl/curl/wiki/DNS-over-HTTPS
One of: adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns pi-dns quad9-recommended

# dns_novpn
Flag to allow DNS lookups directly to the pihole service without Wireguard VPN (exposes Pihole 53/tcp and 53/udp). Useful for local deployments where a traditional DNS service is required.
1 for true, 0 for false

# vpn_traffic
# Generate wireguard client configurations to route only DNS traffic through VPN, or all traffic.
# The wireguard server container does NOT restrict clients, clients can change their AllowedIPs as desired.
One of: dns all

# others
The IP address variables should be changed if they'll conflict/overlap local networks. wireguard_network must not be in the same /24 as docker_<var>s
```

# Client Remote Wireguard Connectivity / Port Forwarding
Port 51820 must be open/forwarded to this host.

# FAQs
- Want to reach the PiHole webUI while away?
  - Connect to the Wireguard VPN and browse to Pihole VPN IP in the terraform output ( by default, its https://172.18.0.5/admin/ - for older installations its http://172.18.0.3/admin/ ).
