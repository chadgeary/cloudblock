# Overview
End-to-end DNS encryption with DNS-based ad-blocking, built in the cloud automatically using Terraform with Ansible. Available for Azure, AWS, GCP, OCI, or as a standalone installation.

Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS) docker containers, as visualized:

![Diagram](diagram.png)

# Instructions
Several deployment options are available, see the README of each subdirectory for platform-specific guides.
- Azure (Microsoft)
- AWS (Amazon)
- GCP (Google)
- OCI (Oracle)
- Standalone (under playbooks/)
