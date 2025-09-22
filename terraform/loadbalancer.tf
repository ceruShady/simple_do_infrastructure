#resource "digitalocean_certificate" "cert" {
#  name             = "cert"
#  private_key      = "file('key.pem')"
#  leaf_certificate = "file('cert.pem')"

#  lifecycle {
#    create_before_destroy = true
#  }
#}

#resource "digitalocean_loadbalancer" "public" {
#  name      = "loadbalancer-1"
#  region    = var.do_region
#  size      = "lb-small"
#  size_unit = 1
#  vpc_uuid  = digitalocean_vpc.do_vpc.id

#  forwarding_rule {
#    entry_port     = 80
#    entry_protocol = "http"

#    target_port     = 80
#    target_protocol = "http"

#certificate_name = digitalocean_certificate.cert.name
#  }

#  forwarding_rule {
#    entry_port     = 443
#    entry_protocol = "https"

#    target_port     = 443
#    target_protocol = "https"

#    tls_passthrough = true
#  }

#  healthcheck {
#    port     = 22
#    protocol = "tcp"
#  }

#  droplet_tag = digitalocean_tag.tag_master.id
#}