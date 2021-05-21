# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in Digital Ocean using Terraform with Ansible+Docker.

![Diagram](../diagram.png)

# Requirements
- A Scaleway cloud account, billing enabled (at least test-level).
- Follow Step-by-Step (compatible with Windows and Ubuntu)

# Step-by-Step
Mac Users install (home)brew, then terraform, git, cloud cli.
```
#########
## Mac ##
#########
# Launch terminal

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure brew up-to-date
brew update

# Install terraform git
brew install terraform git

# Download cloud cli - see latest version and alternative architecture @ https://github.com/scaleway/scaleway-cli/releases
curl -o ~/scw -L "https://github.com/scaleway/scaleway-cli/releases/download/v2.3.0/scw-2.3.0-darwin-x86_64"
chmod +x ~/scw

# Add alias
echo "alias scw ~/scw" >> ~/.bash_profile && source ~/.bash_profile

# Verify the three are installed
which terraform git gcloud scw

# Skip down to 'git clone' below
```

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

# Clone the project
git clone https://github.com/chadgeary/cloudblock

# Create SSH key pair (RETURN for defaults)
ssh-keygen
```

Install the Scaleway CLI and authenticate/generate token+key. A [Scaleway Account](https://console.scaleway.com/register) is required to continue.
```
#############################
##         Scaleway        ##
#############################
# Open powershell and start WSL
wsl

# Change to home directory
cd ~

# WSL Install scaleway-cli via github prebuilt binary
sudo curl -o /usr/local/bin/scw -L "https://github.com/scaleway/scaleway-cli/releases/download/v2.3.0/scw-2.3.0-linux-x86_64"
sudo chmod +x /usr/local/bin/scw

# Generate an API key @ https://console.scaleway.com/project/credentials
# Save the access key and secret key, they're used in the next step and further down under Deploy section.

# Add key to scw when prompted
scw init
```

Customize the deployment - See variables section below
```
# Change to the project's scw directory in powershell
cd ~/cloudblock/scw/

# Open File Explorer in a separate window
# Navigate to the scw project directory - change \chad\ to your WSL username
%HOMEPATH%\ubuntu-1804\rootfs\home\chad\cloudblock\scw

# Edit the scw.tfvars file using notepad and save
```

Deploy
```
# In powershell's WSL window, change to the project's scw directory
cd ~/cloudblock/scw/

# Initialize terraform and the apply the terraform state
terraform init
terraform apply -var-file="scw.tfvars"

# If permissions errors appear, fix with the below command and re-run the terraform apply.
sudo chown $USER scw.tfvars && chmod 600 scw.tfvars

# Terraform outputs two INSTALL commands, use those to start the installation.
```

Want to watch Ansible setup the virtual machine? SSH to the cloud instance - see the terraform output.
```
# Connect to the virtual machine via ssh
ssh ubuntu@<some ip address terraform told us about>

# Tail the cloudblock log file
tail -F /var/log/cloudblock.log
```

# Variables
Edit the vars file (scw.tfvars) to customize the deployment, especially:

```
# ph_password
# password to access the pihole webui

# ssh_key
# A public SSH key for access to the compute instance via SSH, with user ubuntu.
# cat ~/.ssh/id_rsa.pub

# mgmt_cidr
# an IP range granted webUI, instance SSH access. Also permitted PiHole DNS if dns_novpn = 1 (default).
# deploying from home? This should be your public IP address with a /32 suffix. 

# scw_accesskey
# The scaleway access key, used by nextcloud to talk with scaleway's object storage (username)

# scw_secretkey
# The scaleway secret key, used by nextcloud to talk with scaleway's object storage (password)
```

# Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.

# Updates
- See the notes from `terraform output` for scaleway-specific update instructions.
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
cd ~/cloudblock/scw/

# Update the mgmt_cidr variable - be sure to replace change_me with your public IP address
sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" scw.tfvars

# Rerun terraform apply, terraform will update the cloud firewall rules
terraform apply -var-file="scw.tfvars"

# If permissions errors appear, fix with the below command and re-run the terraform apply.
sudo chown $USER scw.tfvars && chmod 600 scw.tfvars
```
