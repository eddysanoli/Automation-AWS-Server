# =================
# VPC
# =================

# Arguments:
# - Resource: "aws_vpc" (Whats going to be deployed)
# - Name: "mtc_vpc" (Internal name for the resource inside of terraform. Doesnt show up in AWS)
resource "aws_vpc" "automation_vpc" {
    cidr_block = "10.1.0.0/24"

    # Enable DNS hostnames (Disabled by default)
    enable_dns_hostnames = true

    # Enable DNS support 
    # (Enabled by default. Included to be explicit about the VPC defaults)
    enable_dns_support = true

    # Name the VPC
    tags = {
        Name = "automation-server-vpc"
    }
}

# =================
# SUBNET
# =================

resource "aws_subnet" "automation_subnet" {

    # We add the VPC ID from the previously created VPC. The ID can be
    # retrieved by referencing the type of resource, followed by the name
    # of the resource and finally the field that you want.
    vpc_id = aws_vpc.automation_vpc.id

    # CIDR must be within the range specified by the CIDR block in the VPC
    cidr_block = "10.1.0.0/24"

    # Assign a public IP on creation
    map_public_ip_on_launch = true

    # We use us-west-2a cause thats a common setup, but you can actually use
    # something called "data sources" to ensure that this is always correct
    availability_zone = "us-east-2c"

    # Name the resource
    tags = {
        Name = "automation-server-subnet"
    }
}