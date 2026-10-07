terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = { Owner = "Dibyo Chakraborty", Enrollment = "24BCS10302", Project = "devops-homework", Session = "19" }
  }
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "container_image" {
  type    = string
  default = "nginx:alpine"
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9./_:@-]*$", var.container_image))
    error_message = "Supply a Docker image reference without whitespace or shell characters."
  }
}

variable "container_port" {
  type    = number
  default = 80
  validation {
    condition     = var.container_port >= 1 && var.container_port <= 65535 && floor(var.container_port) == var.container_port
    error_message = "Container port must be an integer from 1 to 65535."
  }
}

data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "dibyo-24bcs10302-"
  force_destroy = false
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  depends_on                  = [aws_route_table_association.public]
  user_data_replace_on_change = true
  user_data                   = <<-SCRIPT
    #!/bin/bash
    set -eu
    dnf install -y docker
    systemctl enable --now docker
    docker run -d --name homework --restart unless-stopped -p 80:${var.container_port} '${var.container_image}'
  SCRIPT
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  tags = { Name = "dibyo-homework-web" }
}

resource "aws_vpc" "homework" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "dibyo-homework-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.homework.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "dibyo-homework-public" }
}

resource "aws_internet_gateway" "homework" {
  vpc_id = aws_vpc.homework.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.homework.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.homework.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name_prefix = "dibyo-homework-web-"
  description = "HTTP and HTTPS lab traffic; no SSH ingress"
  vpc_id      = aws_vpc.homework.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "vpc_id" {
  value = aws_vpc.homework.id
}
output "vpc_cidr" {
  value = aws_vpc.homework.cidr_block
}
output "subnet_id" {
  value = aws_subnet.public.id
}
output "security_group_id" {
  value = aws_security_group.web.id
}
output "instance_id" {
  value = aws_instance.web.id
}
output "web_url" {
  value = "http://${aws_instance.web.public_ip}"
}
output "bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}
