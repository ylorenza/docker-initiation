#
# Export the following env variables:
#   export AWS_ACCESS_KEY=change-me
#   export AWS_SECRET_KEY=change-me
#   export AWS_REGION=eu-central-1
#


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/ebs-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

variable "instructor" {
  type = "string"
}

variable "students" {
  type = "list"
}

provider "aws" {
  region = "eu-west-1"
//  region = "eu-central-1"
}
