# SSH key 
variable "ssh_pub_key" {
  description = "SSH public key"
  sensitive   = true
}

# General DO resource variables

variable "do_token" {
  description = "Digital Ocean token"
}

#variable "ssh_key_location" {
#  description = "Location of ssh public key"
#  default     = "./secrets/do-admin-key.pub"
#}

variable "do_region" {
  description = "Region for Digital Ocean resources"
  default     = "sgp1"
}

variable "worker_num" {
  description = "Number of worker nodes"
  default     = 2
}

variable "droplet_name_master" {
  description = "Name of master droplet"
  default     = "node-master"
}

variable "droplet_name_worker" {
  description = "Name of worker droplet"
  default     = "node-worker"
}

variable "tag_name_master" {
  description = "Tag name for master"
  default     = "kube-master"
}

variable "tag_name_worker" {
  description = "Tag name for worker"
  default     = "kube-worker"
}

variable "image_master" {
  description = "Image for master instance"
  default     = "ubuntu-24-04-x64"
}

variable "image_worker" {
  description = "Image for worker instance"
  default     = "ubuntu-24-04-x64"
}

variable "size_master" {
  description = "Size configuration for master"
  default     = "s-2vcpu-2gb"
}

variable "size_worker" {
  description = "Size configuration for worker"
  default     = "s-1vcpu-2gb"
}

# DO spaces variables

variable "do_spaces_access" {
  description = "Access ID for Digital Ocean Spaces"
}

variable "do_spaces_secret" {
  description = "Secret key for Digital Ocean Spaces"
}

variable "do_spaces_bucket_name" {
  description = "Name of Digital Ocean Spaces bucket"
  #default     = "my-do-bucket"
}

variable "terraform_state_filename" {
  description = "Name of Terraform state file"
  default     = "terraform.tfstate"
}

variable "ansible_invetory_filename" {
  description = "Name of Ansible inventory file"
  default     = "inventory.yaml"
}

variable "ansible_inventory_location" {
  description = "Location of Ansible inventory file with relation to current working directory"
  default     = "../ansible/inventory.yaml"
}

variable "ansible_inventory_content_type" {
  description = "MIME type of Ansible inventory file"
  default     = "application/yaml"
}

variable "ansible_inventory_template_location" {
  description = "Location of template for Ansible inventory file"
  default     = "./templates/inventory.yaml.tftpl"
}

