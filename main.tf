provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-2.0.*" ]
  }
  filter {
    name = "state"
    values = [ "available" ]
  }
}

resource "aws_instance" "example" {
  ami = "ami-0ceecbb0f30a902a6"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.example_ec2.id]

  user_data = file("./user_data.sh")
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}