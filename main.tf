provider "aws" {
  region = "eu-north-1"
}

# Security Group - for SSH access only
resource "aws_security_group" "ssh_sg" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0511d5dc197f947a5" # You should enter your own VPC ID here.

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Opens SSH for everyone (you can restrict IP addresses if you wish)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_instance" "demo-instance" {
  ami           = "ami-0c4fc5dcabc9df21d" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  key_name      = "project" # Ensure you have created this key pair in the AWS console

  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  tags = {
    Name = "demo-instance"
  }
}
