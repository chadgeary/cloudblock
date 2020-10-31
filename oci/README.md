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

# Authenticate
oci setup keys

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
sudo tail -F /var/log/cloudblock.log
```

# Variables
Edit the vars file (oci.tfvars) to customize the deployment, especially:

```
# oci_config_profile
# The location of the oci config file (created by `oci setup config`)

# oci_root_compartment
# The OCID of the tenancy id (a.k.a. root compartment)

# ph_password
# password to access the pihole webui

# mgmt_cidr
# an IP range granted webUI, EC2 SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix. 

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
```

# Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.
