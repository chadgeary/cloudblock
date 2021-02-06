resource "digitalocean_ssh_key" "do-sshkey" {
  name                              = "${var.do_prefix}-sshkey-${random_string.do-random.result}"
  public_key                        = var.ssh_key
}

resource "digitalocean_floating_ip" "do-ip" {
  region                            = var.do_region
}

resource "digitalocean_droplet" "do-droplet" {
  name                              = "${var.do_prefix}-instance-${random_string.do-random.result}"
  region                            = var.do_region
  private_networking                = "true"
  vpc_uuid                          = digitalocean_vpc.do-network.id
  image                             = var.do_image
  size                              = var.do_size
  ssh_keys                          = [digitalocean_ssh_key.do-sshkey.fingerprint]
  user_data                         = "#!/bin/bash\n# Update package list\napt-get update\n# Install pip3 and git\nDEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git\n# Install ansible\npip3 install --upgrade ansible\n# Make the project directory\nmkdir -p /opt/git/cloudblock\n# Clone project into project directory\ngit clone ${var.project_url} /opt/git/cloudblock\n# Change to directory\ncd /opt/git/cloudblock\n# Ensure up-to-date\ngit pull\n# Change to playbooks directory\ncd playbooks/\n# Execute playbook\nansible-playbook cloudblock_do_bootstrap.yml >> /var/log/cloudblock.log\n"
}

resource "digitalocean_floating_ip_assignment" "do-ip-assignment" {
  ip_address                        = digitalocean_floating_ip.do-ip.ip_address
  droplet_id                        = digitalocean_droplet.do-droplet.id
}
