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

# Step-by-Step Video
By yours truly, for Windows users.
- [Prerequisites](https://youtu.be/9VFexErMlvo) (all deployments should watch this first).

After watching the above, follow a guide specific to your cloud provider.
- [AWS](https://youtu.be/zNElF0iS2bM) (for amazon web services)
- [Azure](https://youtu.be/eZKptCWW-RI) (for microsoft azure cloud)
- [GCP](https://youtu.be/EZyn6dEdqe0) (for google cloud)
- [OCI](https://youtu.be/bVoO6XRNhJs) (for oracle cloud)

# Discussion
[Discord Room](https://discord.gg/zmu6GVnPnj)
