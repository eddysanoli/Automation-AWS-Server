# Gaming Server

Gaming server built to run both Terraria and Minecraft servers, without having to manually provision and configure a virtual machine. Built with Terraform (to provision the AWS infrastructure), Ansible (to configure the server now running in the cloud. Ansible runs inside of a Docker container) and bash. Eventually I want to fully automate it by giving my Discord Bot access to the provisioned server, and then having it run specific commands inside the server to start and stop the gaming servers.

----

## Setup

1. Create the S3 Terraform backend bucket

    ```bash
    # Move to the terraform folder
    cd terraform/s3_terraform_backend

    # Initialize the terraform project
    terraform init

    # Create the S3 bucket used for the Terraform backend
    # (terraform.tfstate will be stored in an S3 bucket)
    terraform apply
    ```

2. Create the S3 bucket for persistent storage

    ```bash
    # Move to the terraform folder
    cd terraform/s3_gaming_server_data

    # Initialize the terraform project
    terraform init

    # Create the S3 bucket used for persistent storage
    # (Make sure to create two folders inside the bucket: minecraft and terraria)
    terraform apply
    ```

3. Add a `terraform.tfvars` file to the `terraform/gaming_server` folder defining the variables found in `terraform/gaming_server/variables.tf`. It's worth mentioning that the Namecheap variables require you to open a Namecheap account, spend at least $50 in domains or services (to unlock API access), and then enable API access. After all of that, just remember to whitelist your IP address to allow the Terraform script to access Namecheap.

4. Create the gaming server infrastructure

    ```bash
    # Move to the terraform folder
    cd terraform/gaming_server

    # Initialize the terraform project
    terraform init

    # Create the gaming server infrastructure
    terraform apply
    ```

5. Provision the server (Installs dependencies, downloads the server executables, provides the proper permissions and syncs different data with the persistent storage S3 bucket)

    ```bash
    # Move to the ansible folder
    cd ansible

    # Run the "provision.yaml" Ansible playbook through the included Docker
    # compose file.
    docker compose up
    ```

----

## Terraform

NOTE: For Terraform, all files in the same directory are going to be processed as if they were the same file. This means that, for example, if we have 3 different `.tf` files, terraform will consider all of them as a single file. Files in terraform are more of a way of organization than an actual functional requirement.

### Files

- `providers.tf`: Setup file. Manages connection to the service that its going to be configured, in this case AWS and Namecheap
- `main.tf`: Declaration of the main components of the cloud infrastructure, like the VPC, subnets, among others.
- `variables.tf`: Variables required by the other scripts. Here only a type and default value declaration exists for each variable.
- `datasources.tf`: External data sources required for the HCL script to run. In this case, the AWS AMI for the EC2 instance and the local IP address through an API request.

### Commands

- `terraform import`: Do you have a resource that was created outside of terraform or lost connection to terraform? Use this command to have terraform manage it again. Solved an issue where an IAM instance profile lost connection to terraform, and then the terraform script was unable to provision AWS because the instance profile "already existed". After importing the instance profile and destroying it, terraform was able to provision the AWS infrastructure again.
