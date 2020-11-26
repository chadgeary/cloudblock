# Instance(s)
resource "aws_instance" "ph-instance2" {
  ami                     = aws_ami_copy.ph-latest-vendor-ami-with-cmk.id
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.ph-instance-profile.name
  key_name                = aws_key_pair.ph-instance-key.key_name
  subnet_id               = aws_subnet.ph-pubnet.id
  private_ip              = var.pubnet_instance_ip2
  vpc_security_group_ids  = [aws_security_group.ph-pubsg.id]
  tags                    = {
    Name                    = "${var.name_prefix}-cloudblock",
    cloudblock             = "True"
  }
  user_data               = <<EOF
#!/bin/bash
# replace systemd-resolved with static dns derived from dhcp
DNS_SERVER=$(systemd-resolve --status | awk -F': ' '/DNS Servers/{print $2}')
systemctl disable systemd-resolved
systemctl stop systemd-resolved
rm -f /etc/resolv.conf
tee /etc/resolv.conf << EOM
nameserver $DNS_SERVER
options edns0
search ec2.internal
EOM
EOF
  root_block_device {
    volume_size             = var.instance_vol_size
    volume_type             = "standard"
    encrypted               = "true"
    kms_key_id              = aws_kms_key.ph-kmscmk-ec2.arn
  }
  depends_on              = [aws_iam_role_policy_attachment.ph-iam-attach-ssm, aws_iam_role_policy_attachment.ph-iam-attach-s3]
}

# Elastic IP for Instance(s)
resource "aws_eip" "ph-eip-2" {
  vpc                     = true
  instance                = aws_instance.ph-instance2.id
  associate_with_private_ip = var.pubnet_instance_ip2
  depends_on              = [aws_internet_gateway.ph-gw]
}
