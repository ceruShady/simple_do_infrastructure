variable "do_token" {
  description = "Digital Ocean token"
}

variable "ssh_key_location" {
  description = "Location of ssh public key"
  default     = "./secrets/do-admin-key.pub"
}

variable "worker_num" {
  description = "Number of worker nodes"
  default     = 1
}