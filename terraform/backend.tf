terraform {
  backend "s3" {
endpoints = {
      s3 = "https://sgp1.digitaloceanspaces.com"
    }

    bucket     = "my-do-bucket" #var.do_spaces_bucket_name
    key        = "terraform.tfstate" #var.terraform_state_filename
    region     = "sgp1" #var.do_region
    access_key = #var.do_spaces_access
    secret_key = #var.do_spaces_secrets
    encrypt    = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
  }
}