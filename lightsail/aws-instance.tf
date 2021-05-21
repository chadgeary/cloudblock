resource "aws_lightsail_key_pair" "ph-key" {
  name                    = "${var.name_prefix}-key"
  public_key              = var.instance_key
}

resource "aws_lightsail_instance" "ph-instance" {
  name                    = "${var.name_prefix}-cloudblock"
  key_pair_name           = aws_lightsail_key_pair.ph-key.name
  availability_zone       = data.aws_availability_zones.ph-azs.names[var.aws_az]
  blueprint_id            = var.blueprint_id
  bundle_id               = var.bundle_id
  tags                    = {
    Name                    = "${var.name_prefix}-cloudblock"
  }
  user_data               = <<EOF
#!/bin/bash
# disable systemd-resolved
DNS_SERVER=$(systemd-resolve --status | awk -F': ' '/DNS Servers/{print $2}')
systemctl disable systemd-resolved
systemctl stop systemd-resolved
rm -f /etc/resolv.conf
tee /etc/resolv.conf << EOM
nameserver $DNS_SERVER
options edns0
search ec2.internal
EOM

# install ssm
sudo snap install amazon-ssm-agent --classic

# register
systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent.service
/snap/amazon-ssm-agent/current/amazon-ssm-agent -register -clear
/snap/amazon-ssm-agent/current/amazon-ssm-agent -register -y -id '${aws_ssm_activation.ph-ssm-activation.id}' -code '${aws_ssm_activation.ph-ssm-activation.activation_code}' -region '${var.aws_region}'
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
EOF
}

resource "aws_lightsail_static_ip" "ph-staticip" {
  name                    = "${var.name_prefix}-staticip"
}

resource "aws_lightsail_static_ip_attachment" "ph-staticipattach" {
  static_ip_name          = aws_lightsail_static_ip.ph-staticip.name
  instance_name           = aws_lightsail_instance.ph-instance.id
}
