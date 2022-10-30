resource "scaleway_instance_security_group" "scw-securitygroup" {
  name                    = "${var.scw_prefix}-securitygroup-${random_string.scw-random.result}"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  external_rules          = true
}

# when client_cidrs
resource "scaleway_instance_security_group_rules" "scw-securitygroup-novpn-clients" {
  count             = var.dns_novpn + length(var.client_cidrs) >= 2 ? 1 : 0
  security_group_id = scaleway_instance_security_group.scw-securitygroup.id
  inbound_rule {
    action   = "accept"
    port     = 22
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 443
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 51820
    protocol = "UDP"
    ip_range = "0.0.0.0/0"
  }
  inbound_rule {
    action   = "accept"
    port     = 53
    protocol = "UDP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 53
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
  dynamic "inbound_rule" {
    for_each = var.client_cidrs
    content {
      action   = "accept"
      port     = 53
      protocol = "UDP"
      ip_range = inbound_rule.value
    }
  }
  dynamic "inbound_rule" {
    for_each = var.client_cidrs
    content {
      action   = "accept"
      port     = 53
      protocol = "TCP"
      ip_range = inbound_rule.value
    }
  }
}

# when dns_novpn = 1 and no client_cidrs
resource "scaleway_instance_security_group_rules" "scw-securitygroup-novpn-noclients" {
  count             = var.dns_novpn > length(var.client_cidrs) ? 1 : 0
  security_group_id = scaleway_instance_security_group.scw-securitygroup.id
  inbound_rule {
    action   = "accept"
    port     = 22
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 443
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 51820
    protocol = "UDP"
    ip_range = "0.0.0.0/0"
  }
  inbound_rule {
    action   = "accept"
    port     = 53
    protocol = "UDP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 53
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
}

# when dns_novpn = 0
resource "scaleway_instance_security_group_rules" "scw-securitygroup-vpn" {
  count             = var.dns_novpn == 0 ? 1 : 0
  security_group_id = scaleway_instance_security_group.scw-securitygroup.id
  inbound_rule {
    action   = "accept"
    port     = 22
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 443
    protocol = "TCP"
    ip_range = var.mgmt_cidr
  }
  inbound_rule {
    action   = "accept"
    port     = 51820
    protocol = "UDP"
    ip_range = "0.0.0.0/0"
  }
}
