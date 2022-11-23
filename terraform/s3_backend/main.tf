/* ============================================ */
/* MAIN TERRAFORM CONFIG                        */
/* ============================================ */

# Configures terraform to use the desired provider for the server (AWS)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

/* ============================================ */
/* AWS PROVIDER                                 */
/* ============================================ */

# Provides access to AWS through a "credentials" file
provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"

  # This one is the name between brackets present inside credentials file
  # (If there's none, add it. eg. "[eddysanoli_admin]")
  profile = "eddysanoli_admin"
}

/* ============================================ */
/* S3 BACKEND TERRAFORM STATE                   */
/* ============================================ */

# S3 bucket for storing the terraform state remotely
resource "aws_s3_bucket" "tf_state_s3_backend" {
  bucket = "eddysanoli-terraform-s3-backend"
  tags = {
    Name = "Stores the terraform.tfstate file for the gaming server remotely"
  }
}

# ACL for s3 bucket
resource "aws_s3_bucket_acl" "tf_state_s3_backend_acl" {
  bucket = aws_s3_bucket.tf_state_s3_backend.id
  acl    = "private"
}
