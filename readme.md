# Simple Digital Ocean instructure with Terraform

## Description
This project demonstrates how to provision cloud infrastructure with DigitalOcean using Terraform IaC. By following the instructions in the following sections, you should be able to provision 2 Droplet instances, a master and a worker instance, with the ability to SSH connect to each instances

## Setting up
Clone the project to your pc
```
git clone https://github.com/ceruShady/simple_do_infrastructure.git
```

## Terraform variables
* do_token: DigitalOcean API token, you can get by accessing the API page at the bottom of the side, beneath Settings

* ssh_key_location: Location of the SSH public key needed to allow for SSH connect to the provisioned instances. Default value will reference to "./secrets/do-admin-key.pub"

* worker_num: Number of worker instances to provision. Only 1 worker instance will be provisioned by default

