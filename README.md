# Overview
End-to-end DNS encryption with DNS-based ad-blocking, built in the cloud automatically using Terraform with Ansible. Available for Azure, AWS, GCP, OCI, or as a standalone installation.

Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS) docker containers, as visualized:

![Diagram](diagram.png)

# Instructions
Several deployment options are available, see the README of each subdirectory for platform-specific guides.
- AWS (Amazon)
- Azure (Microsoft)
- DO (Digital Ocean)
- GCP (Google)
- Lightsail (Fixed-rate/Low-cost AWS)
- OCI (Oracle)
- SCW (Scaleway)
- Standalone Raspberry Pi or Ubuntu Server (under playbooks/)

# Videos
### Standalone Raspberry Pi or Ubuntu Server
Step-by-step, follow along with me as I install on a Raspberry Pi.
- [Raspberry Pi 4+ (Raspbian 10/Buster)](https://youtu.be/9oeQZvltWDc)

### Cloud Deployments
Step-by-step, follow along with me as I deploy from a windows desktop - for Cloud deployments.
- [Prerequisites](https://youtu.be/SJ0hrXPbMNo) (all cloud deployments should watch this first).

After watching the cloud prerequisites video, follow a guide specific to your cloud provider.
- [AWS or Lightsail](https://youtu.be/zNElF0iS2bM) (for amazon web services)
- [Azure](https://youtu.be/eZKptCWW-RI) (for microsoft azure cloud)
- [DO](https://youtu.be/cYOeJpuEuFo) (for digital ocean cloud)
- [GCP](https://youtu.be/EZyn6dEdqe0) (for google cloud)
- [OCI](https://youtu.be/bVoO6XRNhJs) (for oracle cloud)
- [Scaleway](https://youtu.be/jiyEKAixi0w) (for scaleway cloud)

For maintaining the containers running your cloudblock services, see the README (or terraform output) specific to your deployment.

# Discussion
[Discord Room](https://discord.gg/zmu6GVnPnj)
