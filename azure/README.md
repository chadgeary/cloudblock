##### IN PROGRESS #####

# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in Azure using Terraform with Ansible+Docker.

![Diagram](../diagram.png)

# Requirements
- Terraform installed.
- Azure CLI (az) installed and authenticated with a Microsoft Azure account `az login`
- Customized variables (see Variables section).

# Variables
Edit the vars file (oci.tfvars) to customize the deployment, especially:

```
# ph_password
# password to access the pihole webui

# mgmt_cidr
# an IP range granted webUI, EC2 SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix. 

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
```

# Deploy
```
# Clone and change to directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/azure/

# Initialize terraform
terraform init

# Apply terraform
terraform apply -var-file="azure.tfvars"
```

# Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.
