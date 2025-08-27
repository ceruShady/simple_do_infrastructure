variable "do_region" {
  description = "Region for Digital Ocean resources"
  default     = "sgp1"
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
  default     = "s-1vcpu-1gb"
}

variable "size_worker" {
  description = "Size configuration for worker"
  default     = "s-1vcpu-1gb"
}

variable "do_token" {
  description = "Digital Ocean token"
}

variable "ssh_key_location" {
  description = "Location of ssh public key"
  default     = "./secrets/do-admin-key.pub"
}

variable "do_spaces_access" {
  description = "Access ID for Digital Ocean Spaces"
}

variable "do_spaces_secrets" {
  description = "Secret key for Digital Ocean Spaces"
}

variable "worker_num" {
  description = "Number of worker nodes"
  default     = 1
}