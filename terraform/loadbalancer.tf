/*
resource "digitalocean_loadbalancer" "public" {
  name        = "kube-load-balancer"
  region      = var.do_region
  size        = "lb-small"
  size_unit   = 1
  vpc_uuid    = digitalocean_vpc.do_vpc.id
  droplet_tag = digitalocean_tag.tag_master.id

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  #  forwarding_rule {
  #    entry_port     = 443
  #    entry_protocol = "https"

  #    target_port     = 443
  #    target_protocol = "https"

  #    tls_passthrough = true
  #  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }
}*/