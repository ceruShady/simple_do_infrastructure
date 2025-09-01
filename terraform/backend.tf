terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://sgp1.digitaloceanspaces.com"
    }

    # Use GitHub Actions secrets to insert sensitive information
    # e.g. terraform init -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}"
    #bucket     = "<YOUR_BUCKET_NAME>" 
    key = "terraform.tfstate"
    #access_key = "<YOUR_BUCKET_ACCESS_KEY>" 
    #secret_key = "<YOUR_BUCKET_SECRET_KEY>" 
    encrypt = true

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "ap-southeast-1" #var.do_region

    use_lockfile = true
  }
}