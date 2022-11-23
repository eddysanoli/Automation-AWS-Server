# Gaming Server

Gaming server built to run both Terraria and Minecraft servers, without having to manually provision and configure a virtual machine. Built with Terraform (to provision the AWS infrastructure), Ansible (to configure the server now running in the cloud. Ansible runs inside of a Docker container) and bash. Eventually I want to fully automate it by giving my Discord Bot access to the provisioned server, and then having it run specific commands inside the server to start and stop the gaming servers.

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
