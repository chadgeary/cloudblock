# Reference
End-to-end DNS encryption with DNS-based ad-blocking. Combines wireguard (DNS VPN), pihole (adblock), and cloudflared (DNS over HTTPS). Built in OCI using Terraform, Ansible, and Docker.

![Diagram](../diagram.png)

## Requirements
- An Oracle cloud account
- Windows Subsystem for Linux, or Homebrew for Mac
  - Follow Step-by-Step below to satisfy prerequesites

## Step-by-Step
### Mac prerequesites
  - Install - (home)brew, terraform, git, gcloud & oci cli.

  - Important - Apple's Private Relay can prevent access to your cloudblock server/VPN.
  #### Launch Mac terminal

  - Install brew
    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
  - Ensure brew up-to-date
    ```sh
    brew update
    ```

  - Install terraform git and cli
    ```sh
    brew install terraform git oci-cli
    ```

  - Verify the three are installed
    ```sh
    which terraform git oci-cli
    ```
- After the Mac steps are done, skip down to the [git clone](#clone-the-cloudblock-repository) section below.

### Windows prerequesites
  Windows Subsystem Linux (WSL) installation.
  NOTE: Skip to [WSL Prerequesites](#wsl-prerequesites) if you already have WSL installed.

- Launch an ELEVATED `Powershell` prompt (right click -> Run as Administrator)

  - Enable Windows Subsystem Linux
    ```powershell
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    ```

  - Reboot your Windows PC
    ```powershell
    shutdown /r /t 5
    ```

- After reboot, launch a REGULAR Powershell prompt (left click).
  - IMPORTANT: Do NOT proceed with an ELEVATED Powershell prompt.
  - Download the Ubuntu 2204 package from Microsoft
    ```powershell
    curl.exe -L -o ubuntu-2204.AppxBundle https://aka.ms/wslubuntu2204
    ```

  - Rename the package, unzip it, and cd (change directory)
    ```powershell
    Rename-Item ubuntu-2204.AppxBundle ubuntu-2204.zip
    ```
    ```powershell
    Expand-Archive ubuntu-2204.zip ubuntu-2204
    ```
    ```powershell
    cd ubuntu-2204
    ```

  - Repeat the above three steps for the x64 file, update 0.10.0 if needed
    ```powershell
    Rename-Item ubuntu-2204.0.10.0_x64.zip ubuntu-2204_x64.zip
    ```
    ```powershell
    Expand-Archive ubuntu-2204_x64.zip ubuntu-2204_x64
    ```
    ```powershell
    cd ubuntu-2204_x64
    ```

  - Execute the ubuntu installer
    ```powershell
    .\ubuntu2204.exe
    ```

  - Create a username and password when prompted

### WSL prerequesites

- Install - Terraform, Git, and create an SSH key pair using Windows Subsystem Linux

    - Add terraform's apt key (enter previously created password at prompt)
    ```bash
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    ```

    - Add terraform's apt repository
    ```bash
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    ```

    - Install terraform
    ```bash
    sudo apt-get update && sudo apt-get -y install terraform git
    ```

    - Create SSH key pair (RETURN for defaults)
    ```bash
    ssh-keygen -t rsa -m pem
    ```

### Oracle CLI setup
  - Open Powershell and start WSL, or start a WSL terminal session with Windows Terminal.
    ```powershell
    wsl
    ```
  - Install the Oracle CLI and authenticate. An [OCI account](https://signup.oraclecloud.com/) is required to continue.
  - Change to home directory
    ```sh
    cd ~
    ```
  - Download the oracle CLI installer
    ```sh
    curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh -o oci_install.sh
    ```
  - Run the installer (enter linux password if prompted)
    ```sh
    bash oci_install.sh --accept-all-defaults
    ```
  - Refresh environment
    ```sh
    source ~/.bashrc
    ```

  - Copy user OCID from Oracle Web Console
  - Navigate to Identity -> Users

  - Copy tenancy OCID from Oracle Web Console
  - Navigate to profile (top right) -> Tenancy: <some name>

  - Setup oci CLI with user and tenancy OCID and a default region
    ```sh
    oci setup config
    ```

  - Earlier versions of oci cli did not require entering a passphrase for the private key (including in videos)
  - Instead of generating a separate key, answer this question with your SSH private key's path
  - Enter the location of your API Signing private key file: ~/.ssh/id_rsa

  - Copy contents of your SSH's public key in PEM format to clipboard
    ```sh
    openssl rsa -in ~/.ssh/id_rsa -pubout
    ```

  - Add key via Oracle Web console
  - Navigate to Identity -> Users -> <your user> -> API Keys (Bottom left, under Resources) -> Add Public Key -> Paste Public Keys

  - Note command's output of config file location for vars file
    ```sh
    ls ~/.oci/config
    ```

  - Note command's output of OCI root compartment ID for vars file
    ```sh
    oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]"
    ```

### Clone the cloudblock repository
  - Clone the repository to a local directory.
  - NOTE: it is recommended to be in your home director when this command is run.
    ```bash
    git clone https://github.com/chadgeary/cloudblock
    ```

### Customize deployment
  - See variables section below

  - Change to the project's oci directory
    ```sh
    cd ~/cloudblock/oci/
    ```
  - Edit the `oci.tfvars` file and save
    ```sh
    vi oci.tfvars
    ```

- Alternatively in Windows, open File Explorer in a separate window
- Navigate to oci project directory - change \\`chad`\ to your WSL username
  ```powershell
  %HOMEPATH%\ubuntu-2204\rootfs\home\chad\cloudblock\oci
  ```


## Variables
 - Edit the vars file `oci.tfvars` to customize the deployment, especially:
    ```yaml
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
    # See https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-2204/
    # Find Canonical-Ubuntu-18.04-Minimal, click it then use the OCID of the image in your region
    ```

# Deploy
  - Deploy Cloudblock using Terraform.
    - In powershell's WSL window, change to the project's oci directory
      ```sh
      cd ~/cloudblock/oci/
      ```
    - Initialize terraform and the apply the terraform state
      ```sh
      terraform init
      ```
      ```sh
      terraform apply -var-file="oci.tfvars"
      ```

    - If permissions errors appear, fix with the below command and re-run the terraform apply.
      ```sh
      sudo chown $USER oci.tfvars && chmod 600 oci.tfvars
      ```

    - Note the outputs from terraform after the apply completes

    - Wait for the virtual machine to become ready (Ansible will set up the services for us).
    - TIP: Want to watch Ansible set up the virtual machine?
      - SSH to the cloud instance - see the terraform output.
      - Connect to the virtual machine via ssh
        ```sh
        ssh ubuntu@<some ip address terraform told us about>
        ```
      - Tail the cloudblock log file
        ```sh
        tail -F /var/log/cloudblock.log
        ```

## Post-Deployment
- See terraform output for VPN Client configuration files link and the Pihole WebUI address.

# Updates
- See the notes from `terraform output` for oraclecloud-specific update instructions.
- Important note, if you are familiar with a traditional pihole deployment keep in mind cloudblock uses the docker container which does not follow the same
update path. Cloudblock follows the official pihole (and wireguard) container update instructions:
  - [Pihole](https://github.com/pi-hole/docker-pi-hole#upgrading-persistence-and-customizations)
  - [Wireguard](https://github.com/linuxserver/docker-wireguard)

# FAQs
- Want to reach the PiHole webUI while away?
  - Connect to the Wireguard VPN and browse to Pihole VPN IP in the terraform output:
    - default: https://172.18.0.5/admin/
    - NOTE: for older installs, the default was: http://172.18.0.3/admin/

- Using an ISP with a dynamic IP (DHCP) and the IP address changed? Pihole webUI and SSH access will be blocked until the mgmt_cidr is updated.
  - Follow the steps below to quickly update the cloud firewall using terraform.

    - Open Powershell and start WSL
      ```powershell
      wsl
      ```

    - Change to the project directory
      ```powershell
      cd ~/cloudblock/oci/
      ```

    - Update the mgmt_cidr variable - be sure to replace `change_me` with your public IP address
      ```powershell
      sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"change_me/32\"#" oci.tfvars
      ```

    - Rerun terraform apply, terraform will update the cloud firewall rules
      ```powershell
      terraform apply -var-file="oci.tfvars"
      ```
