# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in OCI using Terraform, Ansible, and Docker.

![Diagram](../diagram.png)

# Requirements
- An Oracle cloud account
- Follow Step-by-Step (compatible with Windows and Ubuntu)

# Step-by-Step
Windows users install WSL (Windows Subsystem Linux)
```
#############################
## Windows Subsystem Linux ##
#############################
# Launch an ELEVATED Powershell prompt (right click -> Run as Administrator)

# Enable Windows Subsystem Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Reboot your Windows PC
shutdown /r /t 5

# After reboot, launch a REGULAR Powershell prompt (left click).
# Do NOT proceed with an ELEVATED Powershell prompt.

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

Install the Oracle CLI and authenticate
```
#############################
##         Oracle          ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# Download the oracle CLI installer
curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh -o oci_install.sh

# Run the installer (enter linux password if prompted)
bash oci_install.sh --accept-all-defaults

# Refresh environment
source ~/.bashrc

# Copy user OCID from Oracle Web Console
# Navigate to Identity -> Users

# Copy tenancy OCID from Oracle Web Console
# Navigate to profile (top right) -> Tenancy: <some name>

# Setup oci CLI with user and tenancy OCID and a default region
oci setup config

# Copy contents of public key to clipboard
cat ~/.oci/oci_api_key_public.pem

# Add key via Oracle Web console
# Navigate to Identity -> Users -> <your user> -> API Keys (Bottom left, under Resource) -> Add Public Key -> Paste Public Keys

# Note command's output of config file location for vars file
ls ~/.oci/config

# Note command's output of OCI root compartment ID for vars file
oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]"
```

Customize the deployment - See variables section below
```
# Change to the project's oci directory in powershell
cd ~/cloudblock/oci/

# Open File Explorer in a separate window
# Navigate to oci project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudblock\oci

# Edit the oci.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's oci directory
cd ~/cloudblock/oci/

# Initialize terraform and the apply the terraform state
terraform init
terraform apply -var-file="oci.tfvars"

# Note the outputs from terraform after the apply completes

# Wait for the virtual machine to become ready (Ansible will setup the services for us)
```

Want to watch Ansible setup the virtual machine? SSH to the cloud instance - see the terraform output.
```
# Connect to the virtual machine via ssh
ssh ubuntu@<some ip address terraform told us about>

# Tail the cloudblock log file
tail -F /var/log/cloudblock.log
```

# Variables
Edit the vars file (oci.tfvars) to customize the deployment, especially:

```
# ph_password
# password to access the pihole webui

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
# cat ~/.ssh/id_rsa.pub

# mgmt_cidr
# an IP range granted webUI, instance SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix.

# oci_config_profile
# The location of the oci config file (created by `oci setup config`)

# oci_root_compartment
# The OCID of the tenancy id (a.k.a. root compartment)

# OCI's managed Ubuntu 18.04 Minimal image, might need to be changed in the future as images are updated periodically
# See https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-1804/
# Find Canonical-Ubuntu-18.04-Minimal, click it then use the OCID of the image in your region
```

# Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.

# FAQs
- Want to reach the PiHole webUI while away?
  - Connect to the Wireguard VPN and browse to Pihole VPN IP in the terraform output ( by default, its https://172.18.0.5/admin/ - for older installations its http://172.18.0.3/admin/ ).

- Using an ISP with a dynamic IP (DHCP) and the IP address changed? Pihole webUI and SSH access will be blocked until the mgmt_cidr is updated.
  - Follow the steps below to quickly update the cloud firewall using terraform.

```
# Open Powershell and start WSL
wsl

# Change to the project directory
cd ~/cloudblock/oci/

# Update the mgmt_cidr variable - be sure to replace change_me with your public IP address
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" oci.tfvars

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="oci.tfvars"
```

- How do I update Pihole / Wireguard docker containers?
  - Review [Pihole](https://github.com/pi-hole/docker-pi-hole#upgrading-persistence-and-customizations) and [Wireguard](https://github.com/linuxserver/docker-wireguard) container update instructions.
  - Cloudblock follows these instructions and provides steps in the terraform output. Be sure cloudblock is locally up-to-date to display the instructions:
```
# Be in the oci subdirectory
cd ~/cloudblock/oci/

# Move vars file to be untracked by git, if not already done.
if [ -f pvars.tfvars ]; then echo "pvars exists, not overwriting"; else mv oci.tfvars pvars.tfvars; fi

# Pull cloudblock updates
git pull

# Note any new variables in the default vars file compared to your original (pvars.tfvars), add any new variables to pvars.tfvars
diff pvars.tfvars oci.tfvars

# Re-run terraform apply with your pvars file, see the update instructions in terraform's output
terraform apply -var-file="pvars.tfvars"
```
