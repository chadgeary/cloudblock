resource "digitalocean_vpc" "do-network" {
  name                              = "${var.do_prefix}-network-${random_string.do-random.result}"
  region                            = var.do_region
  ip_range                          = var.do_cidr
}

# if novpn and client cidrs
resource "digitalocean_firewall" "do-firewall-combo" {
  count                             = var.dns_novpn + length(var.client_cidrs) >= 2 ? 1 : 0
  name                              = "${var.do_prefix}-firewall-${random_string.do-random.result}"
  droplet_ids                       = [digitalocean_droplet.do-droplet.id]
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "22"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "443"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "53"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "udp"
    port_range                        = "53"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "53"
    source_addresses                  = var.client_cidrs
  }
  inbound_rule {
    protocol                          = "udp"
    port_range                        = "53"
    source_addresses                  = var.client_cidrs
  }
  inbound_rule {
    protocol                          = "udp"
    port_range                        = "51820"
    source_addresses                  = [var.vpn_cidr]
  }
  outbound_rule {
    protocol                          = "tcp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol                          = "udp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
}

# if dns_novpn = 1 and no client cidrs
resource "digitalocean_firewall" "do-firewall-dns" {
  count                             = var.dns_novpn > length(var.client_cidrs) ? 1 : 0
  name                              = "${var.do_prefix}-firewall-${random_string.do-random.result}"
  droplet_ids                       = [digitalocean_droplet.do-droplet.id]
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "22"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "443"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "53"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "udp"
    port_range                        = "53"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "udp"
    port_range                        = "51820"
    source_addresses                  = [var.vpn_cidr]
  }
  outbound_rule {
    protocol                          = "tcp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol                          = "udp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
}

# if dns_novpn = 0
resource "digitalocean_firewall" "do-firewall-nodns" {
  count                             = var.dns_novpn == 0 ? 1 : 0
  name                              = "${var.do_prefix}-firewall-${random_string.do-random.result}"
  droplet_ids                       = [digitalocean_droplet.do-droplet.id]
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "22"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "443"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "udp"
    port_range                        = "51820"
    source_addresses                  = [var.vpn_cidr]
  }
  outbound_rule {
    protocol                          = "tcp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol                          = "udp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
}
