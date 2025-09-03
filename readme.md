# Simple DigitalOcean instructure with Terraform

## Description
This project demonstrates how to provision cloud infrastructure with DigitalOcean using Terraform IaC. By following the instructions in the following sections, you should be able to provision 2 Droplet instances, a master and a worker instance, with the ability to SSH connect to each instances

## Terraform state files
Terraform remembers the state of the infrastructure and configuration by storing the data into state files typically named "terraform.tfstate" in JSON. Without a state file, Terraform operations will start from scratch. 

## Local backend
Terraform by default creates state file locally on the computer that runs the Terraform apply command. This is referred as local backend, and is suitable for individual developer and state file is locked so that simultaneous Terraform processes won't corrupt the file.

## Remote backend
Remote backend is a configuration where state file is stored in a remote location to allow for collaboration with multiple developers. Commercial cloud storage such as AWS S3 offers encryption for stored files, versioning to allow state rollback, and state lock to prevent more than 1 Terraform processes from modifying and corrupting the state file.

## Setting up

## Creating SSH key
SSH key is required to enable connections to the provisioned infrastructure. You can create a SSH key locally with the following command
```
ssh-keygen
```
Newly created Key public and private key files will be located as ".ssh" directory by default of no name is set for the files. 

You can create SSH key in DigitalOcean, then reference it by name in the Terraform files

You can also create SSH keys through Terraform process then store them in a file locally. However if the process is executed through CI pipelines such GitHub actions, storage of generated key needs to be accounted for, ideally using a secret manager. Also note that information of the generated SSH key is visible in the state file when the key is referenced in the Terraform files

Secure storage of private key information (and passphrase if set) is important to prevent un-authorized access to your infrastructure



## Pre-requisites for Terraform remote backend
DigitalOcean Spaces can be used as remote backend. You will require the following before you can continue:
* Your DigitalOcean Spaces Full Access key ID and Secrets
* A DigitalOcean Spaces bucket already created, which name will be referenced later


## Configuring Terraform for remote backend
You can reference to "backend.tf" for the contents to configure Terraform for remote backend. You will notice that this file does not use variables as it is not allowed by Terraform, so 1 of the ways is to hardcode the information into the file. You can run the following command to reconfigure Terraform for remote backend, you will be prompted for necessary information that is missing in the file
```
terraform init
```

If you wish to keep sensitive information out of the file, you can refer to the following 3 sections for methods to circumvent this.

Note that the line "use_lockfile = true" line enables state lock.

## Using "-backend-config" flag
For Terraform process that runs locally, you can use the "-backend-config" flag
```
terraform init -reconfigure -backend-config="<YOUR_BUCKET_NAME>" -backend-config="access_key=<YOUR_BUCKET_ACCESS_KEY>" -backend-config="secret_key=<YOUR_BUCKET_SECRET_KEY>"
```
## Using "-backend-config" flag with GitHub secrets
For Terraform process running in GitHub actions workflow, you can reference the information using GitHub secrets
```
- name: Terraform Init
    run: |
        terraform init \
            -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}" \
            -backend-config="access_key=${{ secrets.AWS_ACCESS_KEY_ID }}" \
            -backend-config="secret_key=${{ secrets.AWS_SECRET_ACCESS_KEY }}"
```
## Creating backend file before running 
You can also create the backend Terraform file in the workflow before running the "terraform init" command

## Enabling versioning
To enable versioning, run the following command.
```
aws s3api put-bucket-versioning --bucket <YOUR_BUCKET_NAME> --endpoint=<YOUR_ENDPOINT> --versioning-configuration Status=Enabled
```
Note that endpoint provided by DigitalOcean includes the name of bucket, while the endpoint require in the command only need the region (e.g. https://sgp1.digitaloceanspaces.com)

This command works because DigitalOcean Spaces is AWS S3-Compatible

## Additional commands related to file versioning
Command to list the version of the file
```
aws s3api list-object-versions --prefix <FILENAME> --bucket <YOUR_BUCKET_NAME> --endpoint=<YOUR_ENDPOINT>
```

Command to replace the current file with a previous version
```
aws s3api copy-object --bucket <YOUR_BUCKET_NAME> --endpoint=<YOUR_ENDPOINT> --copy-source "<YOUR_BUCKET_NAME>/<FILENAME>?versionId=<VERSION_ID>" --key <FILENAME>
```
Example of file for "--copy-source"
```
"my-do-bucket/terraform.tfstate?versionId=SO5MJfTrUD52XELF1x008cEj0lZtcYx"
```

Command to delete a specific version of the file
```
aws s3api delete-object --bucket <YOUR_BUCKET_NAME> --endpoint=<YOUR_ENDPOINT> --key <FILENAME> --version-id <VERSION_ID>

```

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
### terraform output
After apply a Terraform plan, the IP of provisioned infrastructure is stored as output defined in "output.tf"
```
terraform output
```
You can also specify which output to display based on output name
```
terraform output <OUTPUT_NAME>
```
### terraform state
Terraform provides the "terraform state" command for modfiying state. You can run the following command to list the resource in the state file
```
terraform state list
```

## Terraform variables
* do_token: DigitalOcean API token, you can get by accessing the API page at the bottom of the side, beneath Settings

* ssh_key_location: Location of the SSH public key needed to allow for SSH connect to the provisioned instances. Default value will reference to "./secrets/do-admin-key.pub"

* worker_num: Number of worker instances to provision. Only 1 worker instance will be provisioned by default

## Code scanning with Static Code Analysis tools

Tools such as Checkov or tfsec(soon to be integrated to Trivy) can be employed to identify potential vulnerabilities and policy violations before deployment. Scanning tools can be integrated to CI/CD pipeline to carry out scan operations after each commit.

In this project 2 GitHub actions workflows are created to scan the Terraform files using either Checkov or Trivy and will upload a sarif report at the end of the workflow. The report can be view in the Security section of the GitHub repo, in the Code Scanning page

Note that to enable code scanning in GitHub, the repo needs to be public or Organization-owned repositories on GitHub Team with GitHub Code Security enabled, in addition, workflow permission needs to have read and write permissions

## Security practices
### Modifying state file
While it is possible to directly modify the state file to make changes to the infrastructure, it is recommended to use "terraform state" command to make simple changes, or modify the Terraform files then apply them with the "terraform apply" command"

### Executing Terraform programmatically
Consider using a CI/CD tool to execute Terraform commands to minimize human errors and standardize automated execution process. You can consider using GitHub Actions as CI/CD tool to execute Terraform using files store in the repository. This pipeline can be triggered manually or on release/version tag.

### Secure remote store
Generated state file should store securely in remote cloud (or remote backend for Terraform version < 1.1) for centralized access and to act as single source of truth for the state of your infrastructure. Consider the following when setting cloud storage for your state file:
* Encrypt state file: State files should be encrypted as an added layer of security. You should understand the encryption practices of your cloud storage of choice. Most if not all of the mainstream cloud storage providers provides encryption at rest (DigitalOcean Space, AWS S3 etc), if your cloud storage of choice does not do file encryption, you can consider encrypting your files before storing, however you will have to decrypt your files before you can use them.
* Lock state file: When handling state files in a collaborative environment, it is important to implement state file lock to prevent concurrent operations and potential state file corruption. Method to enable state file lock will differ based on your cloud storage of choice.
* Versioning state file: State file should be versioned to track changes and allow for state rollbacks. To execute a rollback, the current version of "terraform.tfstate" should be backup in another location then replaced with an older version, then run "terraform plan" to show difference between the desired state based on "terraform.tfstate" file and the current configuration, and "terraform apply" to execute the rollback.

### Other security practices
* Separate secrets from your Terraform code: Avoid hardcoding sensitive information in your Terraform code, you can use the (sensitive()) function in resources or "sensitive=true" in variable or output to prevent sensitive data from being displayed in output from plan or apply operations. It is also recommended to use secrets storage functionality provided by your CI/CD tool or cloud provider to store sensitive information then feed it to Terraform command as needed.
* Security scan on Terraform files: Refer to the "Code scanning with Static Code Analysis tools" for more information
* Performing drift detection: Executing "terraform plan" after provisioning the infrastructure will compare the configuration in state file against the current infrastructure configuration. Any drift will be displayed as output.
