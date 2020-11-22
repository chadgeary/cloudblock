# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in AWS with an ARM EC2 instance using Terraform, Ansible, and Docker.

![Diagram](../diagram.png)

# Requirements
- An AWS account
- Follow Step-by-Step (compatible with Windows and Ubuntu)

# Step-by-Step 
Windows Users install WSL (Windows Subsystem Linux)
```
#############################
## Windows Subsystem Linux ##
#############################
# Launch elevated Powershell prompt (right click -> Run as Administrator)
 
# Enable Windows Subsystem Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
 
# Reboot
shutdown /r /t 5
 
# Launch a regular Powershell prompt
 
# Download the Ubuntu 1804 package from Microsoft
curl.exe -L -o ubuntu-1804.appx https://aka.ms/wsl-ubuntu-1804
 
# Rename the package
Rename-Item ubuntu-1804.appx ubuntu-1804.zip
 
# Expand the zip
Expand-Archive ubuntu-1804.zip ubuntu-1804
 
# Change to the zip directory
cd ubuntu-1804
 
# Execute the ubuntu 1804 installer
.\ubuntu1804.exe
 
# Create a username and password when prompted
```
Install Terraform, Git, and create an SSH key pair
```
#############################
##  Terraform + Git + SSH  ##
#############################
# Add terraform's apt key (enter previously created password at prompt)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
 
# Add terraform's apt repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
 
# Install terraform and git
sudo apt-get update && sudo apt-get -y install terraform git
 
# Clone the cloudblock project
git clone https://github.com/chadgeary/cloudblock

# Create SSH key pair (RETURN for defaults)
ssh-keygen
```

Install the AWS cli and create non-root AWS user
```
#############################
##          AWS            ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# Install python3 pip
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install python3-pip

# Install awscli via pip
pip3 install --user --upgrade awscli

# Create a non-root AWS user in the AWS web console with admin permissions
# This user must be the same user running terraform apply
# Create the user at the AWS Web Console under IAM -> Users -> Add user -> Check programmatic access and AWS Management console -> Attach existing policies -> AdministratorAccess -> copy Access key ID and Secret Access key
# See this for more information https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html

# Set admin user credentials
~/.local/bin/aws configure

# Validate configuration
~/.local/bin/aws sts get-caller-identity 
```

Customize the deployment - See variables section below
```
# Change to the project's aws directory in powershell
cd ~/cloudblock/aws/

# Open File Explorer in a separate window
# Navigate to aws project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudblock\aws

# Edit the aws.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's aws directory
cd ~/cloudblock/aws/

# Initialize terraform and apply the terraform state
terraform init
terraform apply -var-file="aws.tfvars"

# Note the outputs from terraform after the apply completes

# Wait for the virtual machine to become ready (Ansible will setup the services for us)
```

Want to watch Ansible setup the virtual machine? SSH to the cloud instance - see the terraform output.
```
# Connect to the virtual machine via ssh
ssh ubuntu@<some ip address terraform told us about>

# Check the Ansible output (from AWS SSM)
export ASSOC_ID=$(sudo bash -c 'ls -t /var/lib/amazon/ssm/*/document/orchestration/' | awk 'NR==1 { print $1 }') && sudo bash -c 'cat /var/lib/amazon/ssm/i-*/document/orchestration/'"$ASSOC_ID"'/awsrunShellScript/runShellScript/stdout'
```

Alternatively, check [AWS State Manager](https://console.aws.amazon.com/systems-manager/state-manager) though you'll need to be logged into AWS as the user created in the previous AWS steps. 

# Variables
Edit the vars file (aws.tfvars) to customize the deployment, especially:
```
# pihole_password
# password to access the pihole webui

# instance_key
# a public SSH key for SSH access to the instance via user `ubuntu`.
# cat ~/.ssh/id_rsa.pub

# mgmt_cidr
# an IP range granted webUI, EC2 SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix.

# kms_manager
# The AWS username (not root) granted access to read the Wireguard VPN configuration files in S3.
```

# Post-Deployment
- Wait for Ansible Playbook, watch [AWS State Manager](https://console.aws.amazon.com/systems-manager/state-manager)
- See terraform output for VPN Client configuration link and the Pihole WebUI address.

# FAQs
- Want to reach the PiHole webUI while away?
  - Connect to the Wireguard VPN and browse to Pihole VPN IP in the terraform output ( by default, its https://172.18.0.5/admin/ - for older installations its http://172.18.0.3/admin/ ).

- Using an ISP with a dynamic IP (DHCP) and the IP address changed? Pihole webUI and SSH access will be blocked until the mgmt_cidr is updated.
  - Follow the steps below to quickly update the cloud firewall using terraform.

```
# Open Powershell and start WSL
wsl

# Change to the project directory
cd ~/cloudblock/aws/

# Update the mgmt_cidr variable - be sure to replace change_me with your public IP address
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" aws.tfvars

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="aws.tfvars"
```

- How do I update Pihole / Wireguard docker containers?
  - Review [Pihole](https://github.com/pi-hole/docker-pi-hole#upgrading-persistence-and-customizations) and [Wireguard](https://github.com/linuxserver/docker-wireguard) container update instructions.
  - Cloudblock follows these instructions, but containers must be removed manually first:
  - SSH to the cloudblock instance.
  - Remove the pihole or wireguard container (local data is kept), e.g.:
```
sudo docker rm -f pihole
# and/or
sudo docker rm -f wireguard
```
  - Re-apply the AWS SSM association to re-run the Ansible playbook. Ansible will re-install Pihole / Wireguard.
  - Newer versions of cloudblock display an AWS CLI command to re-apply the AWS SSM association, otherwise:
  - Visit https://console.aws.amazon.com/systems-manager/state-manager/ (be in the proper AWS region) -> select the association -> click 'Apply association now'
