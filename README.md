# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in AWS with an ARM EC2 instance using Terraform, Ansible, and Docker.

![Diagram](diagram.png)

# Requirements
- Terraform installed.
- AWS credentials (e.g. `aws configure` if awscli is installed) and a non-root AWS IAM user.
- Customized variables (see Variables section).

# Variables
Edit the vars file (ph.tfvars) to customize the deployment, especially:

**bucket_name**

- a unique bucket name, terraform will create the bucket to store various resources.

**mgmt_cidr**

- an IP range granted webUI, EC2 SSH access. Also permitted PiHole DNS if dns_novpn = 1
- deploying from home? This should be your public IP address with a /32 suffix. 

**vpn_cidr**

- an IP range granted wireguard VPN access. Client enrollment still required.
- default is 0.0.0.0/0 (world)

**kms_manager**

- an AWS user account (not root) granted access to the encrypted S3 objects.
- required to read the VPN configuration files in S3.

**instance_key**

- a public SSH key for SSH access to the instance via user `ubuntu`.

**ssm_web_password**

- Sets the Pihole WebUI password.

# Deploy
```
# Initialize terraform
terraform init

# Apply terraform - the first apply takes a while creating an encrypted AMI.
terraform apply -var-file="ph.tfvars"
```

# Post-Deployment
- Wait for Ansible Playbook, watch [AWS State Manager](https://console.aws.amazon.com/systems-manager/state-manager)
- See terraform output for VPN Client configuration link and the Pihole WebUI address.
