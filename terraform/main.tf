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

# CREATE THE SSH KEY
resource "aws_key_pair" "waycarbon-challenge-key" {
  key_name   = "waycarbon-challenge"
  public_key = <<-EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6H3sk1xYPG6tm396jjeXsO1WMdtAEeiKvH9hz8avvgCJ4TooN3daGsACT
    9qUeUX2k+NToNkC++tJjGDsWbjMID6cYvupioag+Bg0p6EVKy2DCVSndgQjIKVfmWxZdrC2bRj2AkQbOYeKken3mbzk4RRTw
    9N8knahT1KB7yZFrIhNdgwHk24xWlErPQ8sVvdfqhw7Dm7due0HTziTZShCkUSv+Kq4c5xhezNfWBVMCRB7zbw32CAo2lfpx
    005QqpGneqX2i5649OKBHbanraS7e/Z47ZkZwfrnBzJXYwP/omI+2hQe5dz4gkl8IsOEsfb7jwrst6EDWt0hu7t639CGNVrJ
    QxCk3peFkCky1Kg2vw1drdI4XHTH5aiNe3SMMPMuQaqfFo/Bsp83XEkscB8uhrNLPsw5CUxt0ATrd6cOojRObYIWjbsUXgu/
    0rvzBgJQeP6cvyhBG5mVwDpUluvk5DjQIIt/MTpP7VioMLWm1ctzkwfGsfAlEZoPZNFCRas=
  EOT
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
    Name = "WayCarbon Challenge"
  }
}
