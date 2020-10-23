## IN PROGRESS ##

# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in OCI using Terraform, Ansible, and Docker.

![Diagram](../diagram.png)

# Requirements
- Terraform installed.
- OCI credentials files (e.g. `aws configure` if awscli is installed) and a non-root AWS IAM user.
- Customized variables (see Variables section).

# Variables
Edit the vars file (ph.tfvars) to customize the deployment, especially:

```
# pihole_password
# password to access the pihole webui

# mgmt_cidr
# an IP range granted webUI, EC2 SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix. 
```

# Deploy
```
# Clone and change to directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/oci/

# Initialize terraform
terraform init

# Apply terraform - the first apply takes a while creating an encrypted AMI.
terraform apply -var-file="ph.tfvars"
```

# Post-Deployment
- See terraform output for VPN Client configuration link and the Pihole WebUI address.
