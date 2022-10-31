/* ============================================ */
/* TERRAFORM PROVIDERS                          */
/* ============================================ */

# Configures terraform to use the desired provider for the server (AWS)
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
        namecheap = {
            source = "namecheap/namecheap"
            version = ">= 2.0.0"
        }
    }
}


/* ============================================ */
/* AWS                                          */
/* ============================================ */

# Provider block
# Provides the information to access AWS specifically
# (Credentials can also be provided through other methods, but this method
# uses the already existing credentials file)
provider "aws" {
    region                  = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"

    # This one is the name between brackets present inside credentials file
    # (If there's none, add it. eg. "[eddysanoli_admin]")
    profile                 = "eddysanoli_admin"
}

/* ============================================ */
/* NAMECHEAP                                    */
/* ============================================ */

# Namecheap API credentials
provider "namecheap" {
    user_name = "${var.NAMECHEAP_USER}"
    api_user = "${var.NAMECHEAP_USER}"
    api_key = "${var.NAMECHEAP_API_KEY}"
}