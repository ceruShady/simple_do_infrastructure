# Generate SSH key
#resource "tls_private_key" "ssh_key_pair" {
#  algorithm = "ED25519"
#}

# Reference generated SSH key
#resource "digitalocean_ssh_key" "admin_ssh_key" {
#  name       = "do-admin-key"
#  public_key = sensitive(tls_private_key.ssh_key_pair.public_key_openssh)
#}

# Reference SSH public
resource "digitalocean_ssh_key" "admin_ssh_key" {
  name       = "do-admin-key"
  public_key = sensitive(var.ssh_pub_key)
}

# Referencing to SSH uploaded in DigitalOcean
#resource "digitalocean_ssh_key" "existing_key" {
#  name = "<NAME_OF_SSH_KEY>" # Or use fingerprint = "your_key_fingerprint"
#}

# Output generated SSH key
#output "private_key_openssh" {
#  value     = tls_private_key.ssh_key_pair.private_key_openssh
#  sensitive = true
#}

# Save generated SSH private key
#resource "local_file" "private_key_file" {
#  content         = tls_private_key.ssh_key_pair.private_key_openssh
#  filename        = "./secrets/my_droplet_key.pem"
#  file_permission = "0600"
#}
