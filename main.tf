resource "digitalocean_droplet" "master" {
  name     = "master"
  image    = "ubuntu-24-04-x64"
  region   = "sgp1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.admin_ssh_key.id]
}

resource "digitalocean_droplet" "workers" {
  count    = var.worker_num
  name     = "worker-${count.index}"
  image    = "ubuntu-24-04-x64"
  region   = "sgp1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.admin_ssh_key.id]
}

output "worker_ids" {
  value = digitalocean_droplet.workers.*.id
}

resource "digitalocean_firewall" "cluster_firewall" {
  name = "cluster-firewall"
  inbound_rule {
    protocol           = "tcp"
    port_range         = "22"
    source_addresses   = ["0.0.0.0/0"]
    source_droplet_ids = [digitalocean_droplet.master.id] # Allow SSH from master
  }
  # ... other rules ...
  droplet_ids = [digitalocean_droplet.master.id,
  join(", ", [for i in digitalocean_droplet.workers : i.id])]
}

resource "digitalocean_ssh_key" "admin_ssh_key" {
  name       = "do-admin-key"
  public_key = file(var.ssh_key_location)
}

