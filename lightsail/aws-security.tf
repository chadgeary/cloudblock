resource "aws_lightsail_instance_public_ports" "ph-ports-dnsonlyvpn" {
  count                   = var.dns_novpn == 0 ? 1 : 0
  instance_name           = aws_lightsail_instance.ph-instance.name
  port_info {
    protocol                = "tcp"
    from_port               = "22"
    to_port                 = "22"
    cidrs                   = [var.mgmt_cidr]
  }
  port_info {
    protocol                = "tcp"
    from_port               = "443"
    to_port                 = "443"
    cidrs                   = [var.mgmt_cidr]
  }
  port_info {
    protocol                = "udp"
    from_port               = "51820"
    to_port                 = "51820"
    cidrs                   = [var.vpn_cidr]
  }
}

resource "aws_lightsail_instance_public_ports" "ph-ports-dnsnovpn" {
  count                   = var.dns_novpn == 1 ? 1 : 0
  instance_name           = aws_lightsail_instance.ph-instance.name
  port_info {
    protocol                = "tcp"
    from_port               = "22"
    to_port                 = "22"
    cidrs                   = [var.mgmt_cidr]
  }
  port_info {
    protocol                = "tcp"
    from_port               = "443"
    to_port                 = "443"
    cidrs                   = [var.mgmt_cidr]
  }
  port_info {
    protocol                = "udp"
    from_port               = "51820"
    to_port                 = "51820"
    cidrs                   = [var.vpn_cidr]
  }
  port_info {
    protocol                = "udp"
    from_port               = "53"
    to_port                 = "53"
    cidrs                   = concat([var.mgmt_cidr],var.client_cidrs)
  }
}
