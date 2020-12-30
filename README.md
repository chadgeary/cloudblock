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

# Videos
### Raspberry Pi
Step-by-step, follow along with me - for Raspberry Pi deployments.
- [Raspberry Pi 4+ (Raspbian 10/Buster)](https://youtu.be/9oeQZvltWDc)

### Cloud Deployments
Step-by-step, follow along with me from a windows desktop - for Cloud deployments.
- [Prerequisites](https://youtu.be/9VFexErMlvo) (all cloud deployments should watch this first).

After watching the cloud prerequisites video, follow a guide specific to your cloud provider.
- [AWS](https://youtu.be/zNElF0iS2bM) (for amazon web services)
- [Azure](https://youtu.be/eZKptCWW-RI) (for microsoft azure cloud)
- [GCP](https://youtu.be/EZyn6dEdqe0) (for google cloud)
- [OCI](https://youtu.be/bVoO6XRNhJs) (for oracle cloud)

For maintaining a cloud-based cloudblock deployment, follow:
- [Maintenance/Updates](https://youtu.be/jWDMsXy_-6Q) (all clouds, AWS-specific steps start at 8:30)

# Discussion
[Discord Room](https://discord.gg/zmu6GVnPnj)
