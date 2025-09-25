output "vpc_id" {
  description = "ID of VPC"
  value       = digitalocean_vpc.do_vpc.id
}


output "master_ip_addr" {
  description = "IPv4 address of provisioned master instance"
  value       = digitalocean_droplet.droplet_master.ipv4_address
  sensitive   = true
}

output "worker_ip_addr" {
  description = "IPv4 address of provisioned instances"
  value       = digitalocean_droplet.droplet_workers.*.ipv4_address
  sensitive   = true
}

output "master_id" {
  value = digitalocean_droplet.droplet_master.id
}

output "worker_ids" {
  value = digitalocean_droplet.droplet_workers.*.id
}

output "worker_ids_arr" {
  value = join(", ", [for i in digitalocean_droplet.droplet_workers : i.id])
}