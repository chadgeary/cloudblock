# security groups
resource "aws_security_group" "ph-pubsg" {
  name        = "ph-pubsg"
  description = "Security group for public traffic"
  vpc_id      = aws_vpc.ph-vpc.id
  tags = {
    Name = "ph-pubsg"
  }
}

# public sg rules
resource "aws_security_group_rule" "ph-pubsg-mgmt-ssh-in" {
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "ingress"
  description       = "IN FROM MGMT - SSH MGMT"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "ph-pubsg-mgmt-https-in" {
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "ingress"
  description       = "IN FROM MGMT - HTTPS"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "ph-pubsg-mgmt-dnstcp-in" {
  count             = var.dns_novpn * 1
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "ingress"
  description       = "IN FROM MGMT - DNS TCP"
  from_port         = "53"
  to_port           = "53"
  protocol          = "tcp"
  cidr_blocks       = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "ph-pubsg-client-dnstcp-in" {
  count             = length(var.client_cidrs) == 0 ? 0 : 1
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "ingress"
  description       = "IN FROM CLIENT - DNS TCP"
  from_port         = "53"
  to_port           = "53"
  protocol          = "tcp"
  cidr_blocks       = var.client_cidrs
}

resource "aws_security_group_rule" "ph-pubsg-mgmt-dnsudp-in" {
  count             = var.dns_novpn * 1
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "ingress"
  description       = "IN FROM MGMT - DNS UDP"
  from_port         = "53"
  to_port           = "53"
  protocol          = "udp"
  cidr_blocks       = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "ph-pubsg-client-dnsudp-in" {
  count             = length(var.client_cidrs) == 0 ? 0 : 1
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "ingress"
  description       = "IN FROM CLIENT - DNS TCP"
  from_port         = "53"
  to_port           = "53"
  protocol          = "udp"
  cidr_blocks       = var.client_cidrs
}

resource "aws_security_group_rule" "ph-pubsg-mgmt-wireguard-in" {
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "ingress"
  description       = "IN FROM WORLD - WIREGUARD"
  from_port         = "51820"
  to_port           = "51820"
  protocol          = "udp"
  cidr_blocks       = [var.vpn_cidr]
}

resource "aws_security_group_rule" "ph-pubsg-out-tcp" {
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "egress"
  description       = "OUT TO WORLD - TCP"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ph-pubsg-out-udp" {
  security_group_id = aws_security_group.ph-pubsg.id
  type              = "egress"
  description       = "OUT TO WORLD - UDP"
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}
