# Simple Digital Ocean instructure with Terraform

## Description
This project demonstrates how to provision cloud infrastructure with DigitalOcean using Terraform IaC. By following the instructions in the following sections, you should be able to provision 2 Droplet instances, a master and a worker instance, with the ability to SSH connect to each instances

## Setting up
### Cloning the project
Clone the project to your pc
```
git clone https://github.com/ceruShady/simple_do_infrastructure.git
```
### Generating the SSH key
After cloning the project, create a "secrets" directory at the root of the project

Open a terminal at the created directory and enter the following command to start the process of creating a SSH keypair.
```
ssh-keygen
```
When generating a keypair, you will be requested to enter the name of the keypair, enter "do-admin-key" and leave the passphrase prompt empty. You can change the name or the location of the flie if you wish, but you will have to make the change in variable.tf, default value of ssk_key_location

### Setting up Terraform
Open a terminal at the root directory of the project, and enter the following command to download the necessary Terraform components
```
terraform init
```
### Validating Terraform files
You can enter the following command to check if the configuration syntax in the Terraform files are valid
```
terraform validate
```
### Formatting Terraform files
Enter the following command to format the code in the Terraform file after making changes
```
terraform fmt
```
### terraform plan
Create an execution plan to review with the following command, Terraform will request for DigitalOcean API, so enter the information as requested
```
terraform plan
```
You can also use "-var" to feed in your API token
```
terraform plan -var do_token=<YOUR_API_TOKEN>
```
Execution plan can be output to a file to be applied later
```
terraform plan -var do_token=<YOUR_API_TOKEN> -out <OUTPUT_FILENAME.tfplan>
```
### terraform apply
Once you are satisfied with the execution plan, enter the following command to apply the execution plan
```
terraform apply
```
You will be prompt on whether to proceed with the execution plan, enter "yes" to proceed. You can also enter the following to proceed without prompting
```
terraform apply -auto-approve
```
Note that the above 2 apply commands will generate an execution plan as though "terraform plan is executed so you will be prompt to enter the variables that does not have a default value, refer to terraform plan section

If you have output the execution plan to a file, you can reference it in the command
```
terraform apply <OUTPUT_FILENAME.tfplan>
```
Note that you will not be prompt for variables and approval in this case.

You can then verify the provisioned resources in your DigitalOcean account

### terraform destroy
You can enter the following command to destroy the provisioned resources
```
terraform destroy
```
Like terraform apply, you will be prompted for variables and approval. The above command is an alias of "terraform apply -destroy"

You can enter the following command to perform a speculative destroy to see what is affected if the operation goes through
```
terraform plan -destroy
```

## Terraform variables
* do_token: DigitalOcean API token, you can get by accessing the API page at the bottom of the side, beneath Settings

* ssh_key_location: Location of the SSH public key needed to allow for SSH connect to the provisioned instances. Default value will reference to "./secrets/do-admin-key.pub"

* worker_num: Number of worker instances to provision. Only 1 worker instance will be provisioned by default

