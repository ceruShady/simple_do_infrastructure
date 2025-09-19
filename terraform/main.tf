# Provisioned resources
resource "digitalocean_tag" "tag_master" {
  name = var.tag_name_master
}

resource "digitalocean_tag" "tag_worker" {
  name = var.tag_name_worker
}

resource "digitalocean_droplet" "droplet_master" {
  name     = var.droplet_name_master
  image    = var.image_master
  region   = var.do_region
  size     = var.size_master
  ssh_keys = [digitalocean_ssh_key.admin_ssh_key.id]
  tags     = [digitalocean_tag.tag_master.id]
  vpc_uuid = digitalocean_vpc.do_vpc.id
}

resource "digitalocean_droplet" "droplet_workers" {
  count    = var.worker_num
  name     = "${var.droplet_name_worker}-${count.index}"
  image    = var.image_worker
  region   = var.do_region
  size     = var.size_worker
  ssh_keys = [digitalocean_ssh_key.admin_ssh_key.id]
  tags     = [digitalocean_tag.tag_worker.id]
  vpc_uuid = digitalocean_vpc.do_vpc.id
}
