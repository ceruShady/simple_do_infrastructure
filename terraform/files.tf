resource "local_file" "inventory" {
  filename = var.ansible_inventory_location
  content = templatefile(var.ansible_inventory_template_location, {
    master_ip    = digitalocean_droplet.master.ipv4_address
    workers      = digitalocean_droplet.workers.*
  })
  file_permission = "0444"
}

resource "digitalocean_spaces_bucket_object" "inventory" {
  region       = var.do_region
  bucket       = var.do_spaces_bucket_name
  key          = var.ansible_invetory_filename
  source       = local_file.inventory.filename
  content_type = var.ansible_inventory_content_type
}