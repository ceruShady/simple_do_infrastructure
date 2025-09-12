resource "digitalocean_vpc" "do_vpc"{
  name = "project-private-network"
  region = var.do_region
}

resource "digitalocean_firewall" "firewall_master" {
  name = "firewall-master"
  tags = ["master"]

  ### Inbound

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

  # Kubernetes API server
  inbound_rule {
    protocol           = "tcp"
    port_range         = "6443"
    #source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
    source_tags = ["master", "worker"]
  }

  # etcd server client API
  inbound_rule {
    protocol           = "tcp"
    port_range         = "2379-2380"
    #source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
    source_tags = ["master", "worker"]
  }

  # Kubelet API
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10250"
    #source_droplet_ids = [digitalocean_droplet.master.id]
    source_tags = ["master"]
  }

  # kube-controller-manager
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10257"
    #source_droplet_ids = [digitalocean_droplet.master.id]
    source_tags = ["master"]
  }

  # kube-scheduler
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10259"
    #source_droplet_ids = [digitalocean_droplet.master.id]
    source_tags = ["master"]
  }

  # DNS TCP Inbound
  inbound_rule {
    protocol = "tcp"
    port_range = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # DNS UDP Inbound
  inbound_rule {
    protocol = "udp"
    port_range = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # Calico Networking BGP
  inbound_rule {
    protocol = "tcp"
    port_range = "179"
    source_tags = ["master", "worker"]
  }

  # Calico Networking VXLAN
  #inbound_rule {
  #  protocol = "udp"
  #  port_range = "4789"
  #  source_tags = ["master", "worker"]
  #}

  ### Outbound

  # DNS TCP Outbound
  outbound_rule {
    protocol = "tcp"
    port_range = "53"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # DNS UDP Outbound
  outbound_rule {
    protocol = "udp"
    port_range = "53"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # HTTP
  outbound_rule {
    protocol = "tcp"
    port_range = "80"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # HTTPS
  outbound_rule {
    protocol = "tcp"
    port_range = "443"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # ICMP
  outbound_rule {
    protocol              = "icmp"
    destination_addresses  = ["0.0.0.0/0", "::/0"]
  }

  # Calico Networking BGP
  outbound_rule {
    protocol = "tcp"
    port_range = "179"
    destination_tags = ["master", "worker"]
  }

  # Calico Networking VXLAN
  #outbound_rule {
  #  protocol = "udp"
  #  port_range = "4789"
  #  destination_tags = ["master", "worker"]
  #}
}

resource "digitalocean_firewall" "firewall_worker" {
  name = "firewall-worker"
  tags = ["worker"]

  # SSH
  inbound_rule {
    protocol           = "tcp"
    port_range         = "22"
    source_addresses   = ["0.0.0.0/0"]
    #source_droplet_ids = [digitalocean_droplet.master.id] # Connection from Master
    source_tags = ["master"]
  }

  # Kubelet API
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10250"
    #source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
    source_tags = ["master", "worker"]
  }

  # kube-proxy
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10256"
    #source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
    source_tags = ["master", "worker"]
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
    protocol = "tcp"
    port_range = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # DNS UDP Inbound
  inbound_rule {
    protocol = "udp"
    port_range = "53"
    source_addresses = ["0.0.0.0/0"]
  }

  # Calico Networking BGP
  inbound_rule {
    protocol = "tcp"
    port_range = "179"
    source_tags = ["master", "worker"]
  }

  # Calico Networking VXLAN
  #inbound_rule {
  #  protocol = "udp"
  #  port_range = "4789"
  #  source_tags = ["master", "worker"]
  #}

  ### Outbound

  # Kubernetes API server
  outbound_rule {
    protocol           = "tcp"
    port_range         = "6443"
    destination_tags = ["master", "worker"]
  }

  # DNS TCP Outbound
  outbound_rule {
    protocol = "tcp"
    port_range = "53"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # DNS UDP Outbound
  outbound_rule {
    protocol = "udp"
    port_range = "53"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # HTTP
  outbound_rule {
    protocol = "tcp"
    port_range = "80"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # HTTPS
  outbound_rule {
    protocol = "tcp"
    port_range = "443"
    destination_addresses  = ["0.0.0.0/0"]
  }

  # ICMP
  outbound_rule {
    protocol              = "icmp"
    destination_addresses  = ["0.0.0.0/0", "::/0"]
  }

  # Calico Networking BGP
  outbound_rule {
    protocol = "tcp"
    port_range = "179"
    destination_tags = ["master", "worker"]
  }

  # Calico Networking VXLAN
  #outbound_rule {
  #  protocol = "udp"
  #  port_range = "4789"
  #  destination_tags = ["master", "worker"]
  #}
}

