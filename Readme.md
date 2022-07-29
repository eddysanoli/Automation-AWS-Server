# AWS Development and Automation Server

## Terraform

NOTE: For Terraform, all files in the same directory are going to be processed as if they were the same file. This means that, for example, if we have 3 different `.tf` files, terraform will consider all of them as a single file. Files in terraform are more of a way of organization than an actual functional requirement.

### Files

- Providers: Setup file. Manages connection to the service that its going to be configured, in this case AWS.
- Main: Declaration of the main components of the cloud infrastructure, like the VPC, subnets, among others.