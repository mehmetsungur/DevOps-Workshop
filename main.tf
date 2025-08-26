provider "aws" {
  region = "eu-north-1"
}

# VPC
resource "aws_vpc" "my-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

# Subnet
resource "aws_subnet" "my-public-subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

# Route Table
resource "aws_route_table" "my-public-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "my-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "my-public-assoc" {
  subnet_id      = aws_subnet.my-public-subnet.id
  route_table_id = aws_route_table.my-public-rt.id
}

# Security Group - for SSH access only
resource "aws_security_group" "demo-instance-sg" {
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
    Name = "demo-instance-sg"
  }
}

resource "aws_instance" "demo-instance" {
  ami           = "ami-0a716d3f3b16d290c" # Ubuntu Server 24.04 LTS (HVM),EBS General Purpose (SSD) Volume Type.
  instance_type = "t3.micro"
  key_name      = "project" # Ensure you have created this key pair in the AWS console

  vpc_security_group_ids = [aws_security_group.demo-instance-sg.id]

  for_each = toset(["Jenkins-master", "build-worker", "ansible"])
  tags = {
    Name = "${each.key}-instance"
  }
}
