# Overview
End-to-end DNS encryption with DNS-based ad-blocking, built in the cloud automatically using Terraform with Ansible. Choose your cloud provider or a standalone installation.

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
As these videos have aged a bit, replace references to Ubuntu 18.04 with Ubuntu 22.04. Text guides are up to date.

### Standalone Raspberry Pi or Ubuntu Server
Step-by-step, follow along with me as I install on a Raspberry Pi.
- Raspberry Pi 4+ (Raspbian 10/Buster) -- [video](https://youtu.be/9oeQZvltWDc) - [guide](./playbooks/README.md)

### Cloud Deployments
Choosing a cloud provider? Watch [this video](https://youtu.be/HB7VwTffdIY) for a mostly un-biased comparison of free options/free trials.

Step-by-step, follow along with me as I deploy from a windows desktop - for Cloud deployments.
  - All cloud deployments should watch this [prerequisites video](https://youtu.be/SJ0hrXPbMNo) first.

After watching the cloud prerequisites video, follow a guide specific to your cloud provider.
  - Amazon Web Services (AWS / Lightsail) - ([video](https://youtu.be/zNElF0iS2bM) - [readme](./azure/README.md))
  - Microsoft Azure (AZW) - ([video](https://youtu.be/eZKptCWW-RI) - [readme](./azure/README.md))
  - Digital Ocean (DO) - ([video](https://youtu.be/cYOeJpuEuFo) - [readme](./do/README.md))
  - Google Cloud Platform (GCP) - ([video](https://youtu.be/EZyn6dEdqe0) - [readme](./gcp/README.md))
  - Oracle Cloud Infrastructure (OCI) - ([video](https://youtu.be/bVoO6XRNhJs) - [readme](./oci/README.md))
  - Scaleway Cloud (SCW) ([video](https://youtu.be/jiyEKAixi0w) - [readme](./scw/README.md))

For maintaining the containers running your cloudblock services, see the README (or terraform output) specific to your deployment. For Cloud deployments, [this video](https://youtu.be/jWDMsXy_-6Q) describes maintenance steps.

# Discussion
[Discord Room](https://discord.gg/zmu6GVnPnj)

# Changelog

### 2022-10
* Added references to Ubuntu 22.04 (replacing Ubuntu 18.04) for:
  * WSL installation
  * Cloud virtual machine images
* Note about Oracle's private key generation for `oci config`