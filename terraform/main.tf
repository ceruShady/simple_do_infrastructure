# Provisioned resources
resource "digitalocean_droplet" "master" {
  name     = "master"
  image    = var.image_master
  region   = var.do_region
  size     = var.size_master
  ssh_keys = [digitalocean_ssh_key.admin_ssh_key.id]
  tags     = ["master"]
}

resource "digitalocean_droplet" "workers" {
  count    = var.worker_num
  name     = "worker-${count.index}"
  image    = var.image_worker
  region   = var.do_region
  size     = var.size_worker
  ssh_keys = [digitalocean_ssh_key.admin_ssh_key.id]
  tags     = ["worker"]
}
