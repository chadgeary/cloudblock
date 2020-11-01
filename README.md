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
- ![Prerequisites](https://youtu.be/tU8sGNf5nFE) (all deployments should watch this first).

After watching the above, follow a guide specific to your cloud provider.
- ![AWS](https://youtu.be/6fhE6ZOGxKY) (for amazon web services)
- ![Azure](https://youtu.be/ttvvaFvvYb8) (for microsoft azure cloud)
- ![Oracle (OCI)](https://youtu.be/yzQ2ypcfPFk) (for oracle cloud)
- ![GCP](https://youtu.be/LQhRCFQbk_c) (for google cloud)
