resource "digitalocean_vpc" "do_vpc" {
  name     = "kube-private-network"
  region   = var.do_region
  ip_range = "10.108.0.0/20"
}

resource "digitalocean_firewall" "firewall_master" {
  name = "firewall-master"
  tags = [digitalocean_tag.tag_master.id]

  ### Inbound

  # ICMP
  inbound_rule {
    protocol    = "icmp"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # SSH
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  # HTTP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  # BGP for Calico CNI
  inbound_rule {
    protocol   = "tcp"
    port_range = "179"
    #source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
    source_addresses = ["0.0.0.0/0"]
  }

  # HTTPS
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  # etcd server client API
  inbound_rule {
    protocol    = "tcp"
    port_range  = "2379-2380"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # Kubernetes API server
  inbound_rule {
    protocol    = "tcp"
    port_range  = "6443"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # Kubelet API
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10250"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # kube-controller-manager
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10257"
    source_tags = [digitalocean_tag.tag_master.id]
  }

  # kube-scheduler
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10259"
    source_tags = [digitalocean_tag.tag_master.id]
  }

  # NodePort Services tcp
  inbound_rule {
    protocol         = "tcp"
    port_range       = "30000-32767"
    source_addresses = ["0.0.0.0/0"]
  }

  # NodePort Services udp
  inbound_rule {
    protocol         = "udp"
    port_range       = "30000-32767"
    source_addresses = ["0.0.0.0/0"]
  }

  # DNS TCP Inbound
  inbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # DNS UDP Inbound
  inbound_rule {
    protocol         = "udp"
    port_range       = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # VXLAN for Calico CNI
  inbound_rule {
    protocol         = "udp"
    port_range       = "4789"
    source_addresses = ["0.0.0.0/0"]
  }

  # Typha for Calico CNI
  inbound_rule {
    protocol    = "tcp"
    port_range  = "5473"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # ingress-nginx
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8443"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  ### Outbound

  # ICMP
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # DNS TCP Outbound
  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  # HTTP
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Calico Networking BGP
  outbound_rule {
    protocol   = "tcp"
    port_range = "179"
    # destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
    destination_addresses = ["0.0.0.0/0"]
  }

  # HTTPS
  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Kubelet API
  outbound_rule {
    protocol         = "tcp"
    port_range       = "10250"
    destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # DNS UDP Outbound
  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  # VXLAN for Calico CNI
  outbound_rule {
    protocol              = "udp"
    port_range            = "4789"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Typha for Calico CNI
  outbound_rule {
    protocol         = "tcp"
    port_range       = "5473"
    destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # ingress-nginx
  outbound_rule {
    protocol         = "tcp"
    port_range       = "8443"
    destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }
}

resource "digitalocean_firewall" "firewall_worker" {
  name = "firewall-worker"
  tags = [digitalocean_tag.tag_worker.id]

  ### Inbound

  # ICMP
  inbound_rule {
    protocol    = "icmp"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # SSH
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  # HTTP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  # BGP for Calico CNI
  inbound_rule {
    protocol   = "tcp"
    port_range = "179"
    # source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
    source_addresses = ["0.0.0.0/0"]
  }

   # HTTPS
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

  # Kubelet API
  inbound_rule {
    protocol   = "tcp"
    port_range = "10250"
    #source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # kube-proxy
  inbound_rule {
    protocol   = "tcp"
    port_range = "10256"
    #source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # NodePort Services tcp
  #inbound_rule {
  #  protocol         = "tcp"
  #  port_range       = "30000-32767"
  #  source_addresses = ["0.0.0.0/0"]
  #}

  # NodePort Services udp
  #inbound_rule {
  #  protocol         = "udp"
  #  port_range       = "30000-32767"
  #  source_addresses = ["0.0.0.0/0"]
  #}

  # DNS TCP Inbound
  inbound_rule {
    protocol         = "tcp"
    port_range       = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # DNS UDP Inbound
  inbound_rule {
    protocol         = "udp"
    port_range       = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # VXLAN for Calico CNI
  inbound_rule {
    protocol         = "udp"
    port_range       = "4789"
    source_addresses = ["0.0.0.0/0"]
  }

  # Typha for Calico CNI
  inbound_rule {
    protocol    = "tcp"
    port_range  = "5473"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # ingress-nginx
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8443"
    source_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  ### Outbound

  # ICMP
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # DNS TCP Outbound
  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  # HTTP
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Calico Networking BGP
  outbound_rule {
    protocol   = "tcp"
    port_range = "179"
    # destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
    destination_addresses = ["0.0.0.0/0"]
  }

  # Calico Networking BGP
  outbound_rule {
    protocol   = "tcp"
    port_range = "179"
    # destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
    destination_addresses = ["0.0.0.0/0"]
  }

  # Calico Goldmane
  outbound_rule {
    protocol              = "tcp"
    port_range            = "7443"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Kubernetes API server
  outbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # Kubelet API
  outbound_rule {
    protocol         = "tcp"
    port_range       = "10250"
    destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # DNS UDP Outbound
  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0"]
  }

  # VXLAN for Calico CNI
  outbound_rule {
    protocol              = "udp"
    port_range            = "4789"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Typha for Calico CNI
  outbound_rule {
    protocol         = "tcp"
    port_range       = "5473"
    destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }

  # ingress-nginx
  outbound_rule {
    protocol         = "tcp"
    port_range       = "8443"
    destination_tags = [digitalocean_tag.tag_master.id, digitalocean_tag.tag_worker.id]
  }
}

