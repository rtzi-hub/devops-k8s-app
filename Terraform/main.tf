provider "aws" {
  region = "us-east-1"
}

# VPC Creation
resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name            = "devops-vpc"
    Devops_Project  = "DevOps Kubernetes Deployment"
  }
}

# Public Subnet Creation
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name            = "public-subnet"
    Devops_Project  = "DevOps Kubernetes Deployment"
  }
}

# IGW Creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name            = "devops-igw"
    Devops_Project  = "DevOps Kubernetes Deployment"
  }
}

# Public Route Table Creation
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/16"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name            = "public-route-table"
    Devops_Project  = "DevOps Kubernetes Deployment"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# SG Creation (Block Access After Deploy)
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-security-group"
  description = "Security group for Kubernetes nodes and SSH access"
  vpc_id      = aws_vpc.devops_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Security Issue! Pay Attention
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # Security Issue! Pay Attention
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Security Issue! Pay Attention
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name            = "k8s-security-group"
    Devops_Project  = "DevOps Kubernetes Deployment"
  }
}

# EC2 Creation - With requirements Installations
resource "aws_instance" "k8s_server" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.medium"
  key_name               = "<Your Key Pem>"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]

  root_block_device {
    volume_size = 15  
    volume_type = "gp3"
  }

  tags = {
    Name            = "Kubernetes-Server"
    Devops_Project  = "DevOps Kubernetes Deployment"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              sudo usermod -aG docker $USER
              sudo systemctl restart docker
              systemctl start docker
              systemctl enable docker


              # Install Minikube
              curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
              install minikube-linux-amd64 /usr/local/bin/minikube

              # Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

              # Install Helm
              curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

              # Install Node.js
              curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
              sudo apt install -y nodejs

              EOF
}

# Outputs (VPC, Public-subnet, K8s-Server PublicIP, SG-ID)
output "vpc_id" {
  value = aws_vpc.devops_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "k8s_server_ip" {
  value = aws_instance.k8s_server.public_ip
}

output "k8s_sg_id" {
  value = aws_security_group.k8s_sg.id
}
