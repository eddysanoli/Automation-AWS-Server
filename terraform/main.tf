/* ============================================ */
/* VPC                                          */
/* ============================================ */

# Arguments:
# - Resource: Whats going to be deployed
# - Name: Internal name for the resource inside of terraform. Doesnt show up in AWS
resource "aws_vpc" "gaming_server_vpc" {
    cidr_block = "10.1.0.0/24"

    # Enable DNS hostnames (Disabled by default)
    enable_dns_hostnames = true

    # Enable DNS support 
    # (Enabled by default. Included to be explicit about the VPC defaults)
    enable_dns_support = true

    # Name the VPC
    tags = {
        Name = "gaming-server-vpc"
    }
}

/* ============================================ */
/* SUBNET                                       */
/* ============================================ */

resource "aws_subnet" "gaming_server_subnet" {

    # We add the VPC ID from the previously created VPC. The ID can be
    # retrieved by referencing the type of resource, followed by the name
    # of the resource and finally the field that you want.
    vpc_id = aws_vpc.gaming_server_vpc.id

    # CIDR must be within the range specified by the CIDR block in the VPC
    cidr_block = "10.1.0.0/24"

    # Assign a public IP on creation
    map_public_ip_on_launch = true

    # We use us-west-2a cause thats a common setup, but you can actually use
    # something called "data sources" to ensure that this is always correct
    availability_zone = "us-east-2c"

    # Name the resource
    tags = {
        Name = "gaming-server-subnet"
    }
}

/* ============================================ */
/* INTERNET GATEWAY                             */
/* ============================================ */

# Give access to our instances through the internet.
resource "aws_internet_gateway" "gaming_server_internet_gateway" {
    
    # Add the VPC ID like before
    vpc_id = aws_vpc.gaming_server_vpc.id

    # Name the resource
    tags = {
        Name = "gaming-server-igw"
    }
}

/* ============================================ */
/* ROUTE TABLE AND ROUTES                       */
/* ============================================ */
# Route traffic from our subnet to our internet gateway

# Publicly Accessible Route Table
resource "aws_route_table" "gaming_server_public_rt" {
    vpc_id = aws_vpc.gaming_server_vpc.id

    # Name the resource
    tags = {
        Name = "gaming_server_public_rt"
    }
}

# Route to Internet Gateway
resource "aws_route" "gaming_server_default_route" {
    route_table_id = aws_route_table.gaming_server_public_rt.id

    # All IP addresses will head to the previously created internet gateway
    destination_cidr_block = "0.0.0.0/0"

    # Set the internet gateway ID where the traffic will be headed to
    gateway_id = aws_internet_gateway.gaming_server_internet_gateway.id
}

# Bridge the gap between our route table and our subnet by creating a 
# route-table association.
resource "aws_route_table_association" "gaming_server_public_association" {
    subnet_id = aws_subnet.gaming_server_subnet.id
    route_table_id = aws_route_table.gaming_server_public_rt.id
}

/* ============================================ */
/* SECURITY GROUP                               */
/* ============================================ */

# Restrict the IPs that can access to the VPC or the IPs accesible from the inside
resource "aws_security_group" "gaming_server_sg" {
    
    # Theres no point in actually having a tag here because the
    # resource actually has a name attribute. You can add a tag
    # but it wont really make a difference.
    name = "gaming-server-sg"
    description = "Gaming Server Security Group"

    # VPC relationship
    vpc_id = aws_vpc.gaming_server_vpc.id

    # Ingress Rules
    # Only allow access from my address
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.PERSONAL_IP}/32"]      
    }

    # Egress Rules
    # All the internet is accessible from the inside
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]             
    }
}

/* ============================================ */
/* KEY PAIR                                     */
/* ============================================ */

# A key pair will be created and then a resource will be created that utilizes this key pair.
# This will be used by the EC2 instance resource we will create so that we can SSH into it
resource "aws_key_pair" "gaming_server_auth" {
    key_name = "gaming_server_key"

    # Created using the command: "ssh-keygen -t ed25519"
    # The key was named "gaming_server_key.pub" and was left with no passphrase
    public_key = file("~/.ssh/id_rsa.pub")
}


/* ============================================ */
/* EC2 INSTANCE                                 */
/* ============================================ */

resource "aws_instance" "gaming_server" {

    # Instance size (t2, t3, ...)
    instance_type = "t2.medium"

    # Image to use for the OS of the instance 
    # (See the names used in the datasource for the AWS 
    #  AMI inside the datasources.tf file)
    # 
    #   ami = data.data_source.data_name
    # 
    ami = data.aws_ami.server_ami.id

    # Use the previously created keypair
    # (You can also use the keypair ID here and it will work)
    key_name = aws_key_pair.gaming_server_auth.key_name

    # Give the instance a security group
    # (Multiple can be provided)
    vpc_security_group_ids = [aws_security_group.gaming_server_sg.id]

    # Add the instance to a subnet
    subnet_id = aws_subnet.gaming_server_subnet.id

    # Increase the size of the disc used by the instance
    # (By default the t2.micro gives you a volume size of 8)
    root_block_device {
        volume_size = 10
    }

    # Name the instance
    tags = {
        Name = "gaming-server"
    }

    # Modify the Ansible's hosts inventory file
    provisioner "local-exec" {

        # Fill content of the hosts file in "ansible/hosts" using the "hosts.tpl" template
        command = templatefile("hosts.tpl", {
            server_ip = self.public_ip
        })

        # Run it using bash
        interpreter = ["bash", "-c"]
    }

}
