#resource "digitalocean_firewall" "cluster_firewall" {
#  name = "cluster-firewall"
#  tags = ["master", "worker"]
#
#  # SSH
#  inbound_rule {
#    protocol           = "tcp"
#    port_range         = "22"
#    source_addresses   = ["0.0.0.0/0"]
#    source_droplet_ids = [digitalocean_droplet.master.id] # Allow SSH from master
#  }
#}

resource "digitalocean_firewall" "firewall_master" {
  name = "firewall_master"
  tags = ["master"]

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
    source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
  }

  # etcd server client API
  inbound_rule {
    protocol           = "tcp"
    port_range         = "2379-2380"
    source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
  }

  # Kubelet API
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10250"
    source_droplet_ids = [digitalocean_droplet.master.id]
  }

  # kube-scheduler
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10259"
    source_droplet_ids = [digitalocean_droplet.master.id]
  }

  # kube-controller-manager
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10257"
    source_droplet_ids = [digitalocean_droplet.master.id]
  }
}

resource "digitalocean_firewall" "firewall_worker" {
  name = "firewall_worker"
  tags = ["worker"]

  # SSH
  inbound_rule {
    protocol           = "tcp"
    port_range         = "22"
    source_addresses   = ["0.0.0.0/0"]
    source_droplet_ids = [digitalocean_droplet.master.id] # Connection from Master
  }

  # Kubelet API
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10250"
    source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
  }

  # kube-proxy
  inbound_rule {
    protocol           = "tcp"
    port_range         = "10256"
    source_droplet_ids = [digitalocean_droplet.master.id, digitalocean_droplet.workers.*.id]
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
}

