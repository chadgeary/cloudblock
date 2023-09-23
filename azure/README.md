# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in Azure using Terraform with Ansible+Docker.

![Diagram](../diagram.png)

# Requirements
- An Azure account
- Follow Step-by-Step (compatible with Windows and Ubuntu)

# Step-by-Step 
Mac Users install (home)brew, then terraform, git, az cli.
```
#########
## Mac ##
#########
# Important - Apple's Private Relay can prevent access to your cloudblock server/VPN.

# Launch terminal

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure brew up-to-date
brew update

# Install terraform and git
brew install terraform git azure-cli

# Verify the three are installed
which terraform git az

# Skip down to 'git clone' below
```

Windows Users install WSL (Windows Subsystem Linux)
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

# Download the Ubuntu 2204 package from Microsoft
curl.exe -L -o ubuntu-2204.AppxBundle https://aka.ms/wslubuntu2204
 
# Rename the package, unzip it, and cd (change directory)
Rename-Item ubuntu-2204.AppxBundle ubuntu-2204.zip
Expand-Archive ubuntu-2204.zip ubuntu-2204
cd ubuntu-2204

# Repeat the above three steps for the x64 file, update 0.10.0 if needed
Rename-Item ubuntu-2204.0.10.0_x64.zip ubuntu-2204_x64.zip
Expand-Archive ubuntu-2204_x64.zip ubuntu-2204_x64
cd ubuntu-2204_x64
 
# Execute the ubuntu installer
.\ubuntu2204.exe
 
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

Install the Azure cli and authenticate. An [azure account](https://azure.microsoft.com/en-us/free/) is required to continue.
```
#############################
##          Azure          ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# Install the azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Authenticate (for WSL users, login to the browser popup!)
az login
```

Customize the deployment - See variables section below
```
# Change to the project's azure directory in powershell
cd ~/cloudblock/azure/

# Open File Explorer in a separate window
# Navigate to azure project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-2204\rootfs\home\chad\cloudblock\azure

# Edit the az.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's azure directory in powershell
cd ~/cloudblock/azure/

# Initialize terraform and apply the terraform state
terraform init
terraform apply -var-file="az.tfvars"

# If permissions errors appear, fix with the below command and re-run the terraform apply.
sudo chown $USER az.tfvars && chmod 600 az.tfvars

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
Edit the vars file (az.tfvars) to customize the deployment, especially:

```
# ph_password
# password to access the pihole webui

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
# cat ~/.ssh/id_rsa.pub
```

>**Note**: Modify `mgmt_cidr` only if you must allow access to the deployed resources from a machine that is **not** the machine that is deploying this code *OR* if you must allow-list IPv6.
```
# mgmt_cidr
# an IP range granted webUI, EC2 SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix.
``` 

# Deploy
```
# Clone and change to directory
git clone https://github.com/chadgeary/cloudblock && cd cloudblock/azure/

# Initialize terraform
terraform init

# Apply terraform
terraform apply -var-file="az.tfvars"
```

# Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.

# Updates
- See the notes from `terraform output` for azure-specific update instructions.
- Important note, if you are familiar with a traditional pihole deployment keep in mind cloudblock uses the docker container which does not follow the same
update path. Cloudblock follows the official pihole (and wireguard) container update instructions:
  - [Pihole](https://github.com/pi-hole/docker-pi-hole#upgrading-persistence-and-customizations)
  - [Wireguard](https://github.com/linuxserver/docker-wireguard)

# FAQs
- Want to reach the PiHole webUI while away?
  - Connect to the Wireguard VPN and browse to Pihole VPN IP in the terraform output ( by default, its https://172.18.0.5/admin - for older installations its http://172.18.0.3/admin/ ).

- Using an ISP with a dynamic IP (DHCP) and the IP address changed? Pihole webUI and SSH access will be blocked until the mgmt_cidr is updated.
  - Follow the steps below to quickly update the cloud firewall using terraform.

```
# Open Powershell and start WSL
wsl

# Change to the project directory
cd ~/cloudblock/azure/

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="az.tfvars"
```
