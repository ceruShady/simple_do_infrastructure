output "master_ip_addr" {
  description = "IPv4 address of provisioned master instance"
  value       = digitalocean_droplet.master.ipv4_address
  sensitive   = true
}

output "worker_ip_addr" {
  description = "IPv4 address of provisioned instances"
  value       = digitalocean_droplet.workers.*.ipv4_address
  sensitive   = true
}

output "worker_ids" {
  value = digitalocean_droplet.workers.*.id
}

output "worker_ids_arr" {
  value = join(", ", [for i in digitalocean_droplet.workers : i.id])
}