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

  # Remotely store the 'terraform.tfstate' file in an S3 bucket.
  backend "s3" {
    bucket                  = "gaming-server-terraform-s3-backend"
    region                  = "us-east-2"
    key                     = "gaming-data-terraform.tfstate"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "eddysanoli_admin"
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
/* GAMING SERVER PERSISTENT STORAGE (S3)        */
/* ============================================ */

# Create a bucket where the server will store persistent data 
# (worlds, saves, metrics, etc.)
resource "aws_s3_bucket" "gaming_server_bucket" {
  bucket = "gaming-server-data"

  tags = {
    Name = "Persistant Data for the Noobsquad Gaming Server"
  }
}
