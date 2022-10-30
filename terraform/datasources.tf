/* ============================================ */
/* SERVER AMI                                   */
/* ============================================ */

# Image that will be used for the OS of the EC2 instance
data "aws_ami" "server_ami" {
    most_recent = true

    # Get the owner ID from the AWS console. You can find it by finding
    # the AMI ID that you want when you are going to deploy an EC2 instance,
    # going into the AMI service, filtering by the AMI ID and then finally
    # looking at the owner ID. In this case, this is the filter for Ubuntu 18
    owners = ["099720109477"]

    # Add filters to get the correct AMI
    filter {

        # Filter by name
        name = "name"

        # After "server-" we should have a date. This is the date of the image,
        # but here we put an asterisk instead to indicate that we want the most
        # recent always
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
}