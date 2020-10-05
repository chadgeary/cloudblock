# Reference
A pihole in AWS. Built using an ARM EC2 instance running Amazon Linux 2 with Terraform (and Ansible).

# Requirements
- Terraform installed.
- AWS credentials (e.g. `aws configure` if awscli is installed)
- Customized variables (see Variables section).

# Variables
Edit the vars file (ph.tfvars) to customize the deployment, especially:

**bucket_name**

- a unique bucket name, terraform will create the bucket to store various resources.

**mgmt_cidr**

- an IP range granted webUI and EC2 SSH access.
- deploying from home? This should be your public IP address with a /32 suffix. 

**kms_manager**

- an AWS user account (not root) that will be granted access to the KMS key (to read S3 objects).

**instance_key**

- a public SSH key for SSH access to instances via user `ec2-user`.

**ssm_**

- additional pihole related variables, including the web console password.

# Deploy
```
# Initialize terraform
terraform init

# Apply terraform - the first apply takes a while creating an encrypted AMI.
terraform apply -var-file="ph.tfvars"

# Wait for SSM to run the Ansible Playbook (workstation/), watch:
https://console.aws.amazon.com/systems-manager/state-manager
```

# Typical Use
- Set home router's DNS to IP address of PiHole (output by Terraform).
