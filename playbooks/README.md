# Local Deployment
`cloudblock_amd64.yml` and `cloudblock_arm64.yml` support standalone deployments.

# Requirements
- Ubuntu 18.04+
- Ansible installed

# Deploy
```
# Clone and change to directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/playbooks/

# Run playbook (target is the localhost)
ansible-playbook cloudblock_amd64.yml --extra-vars 'docker_network=172.18.0.0 docker_gw=172.18.0.1 docker_doh=172.18.0.2 docker_pihole=172.18.0.3 docker_wireguard=172.18.0.4 wireguard_network=172.19.0.0 doh_provider=opendns dns_novpn=1'

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

# others
The IP address variables should be changed if they'll conflict/overlap local networks. wireguard_network must not be in the same /24 as docker_<var>s
```

# Client Remote Wireguard Connectivity / Port Forwarding
Port 51820 must be open/forwarded to this host.
