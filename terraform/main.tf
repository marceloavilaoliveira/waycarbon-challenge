terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# DEFINE THE AWS REGION
provider "aws" {
  region = "sa-east-1"
}

# DECLARE THE PUBLIC_KEY VARIABLE
variable "public_key" {
  type = string
  description = "SSH public key"
}

# CREATE THE SSH KEY
resource "aws_key_pair" "waycarbon-challenge-key" {
  key_name   = "waycarbon-challenge"
  public_key = var.public_key
}

# CREATE THE SECURITY GROUP
resource "aws_security_group" "waycarbon-challenge-sg" {
  name        = "waycarbon-challenge-sg"
  description = "Security group for WayCarbon Challenge"

  # CREATE THE INBOUND PORT 80 RULE
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # CREATE THE INBOUND PORT 22 RULE
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # CREATE THE OUTBOUND RULE
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATE THE INSTANCE
resource "aws_instance" "waycarbon-challenge-instance" {
  ami           = "ami-0af6e9042ea5a4e3e"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.waycarbon-challenge-sg.id]
  key_name               = aws_key_pair.waycarbon-challenge-key.key_name

  tags = {
    Name = "waycarbon-challenge"
  }
}
