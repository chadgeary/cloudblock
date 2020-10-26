# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in OCI using Terraform, Ansible, and Docker.

![Diagram](../diagram.png)

# Requirements
- Terraform installed.
- OCI CLI installed and an API key generated / uploaded via `oci setup config`, add via OCI web console under Identity -> Users -> User Details -> API Keys
- Customized variables (see Variables section).

# Variables
Edit the vars file (oci.tfvars) to customize the deployment, especially:

```
# oci_config_profile
# The location of the oci config file (created by `oci setup config`), e.g. /home/chad/.oci/config

# oci_root_compartment
# The OCID of the tenancy id (or root compartment), try:
oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]"

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
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/oci/

# Initialize terraform
terraform init

# Apply terraform
terraform apply -var-file="oci.tfvars"
```

# Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.
