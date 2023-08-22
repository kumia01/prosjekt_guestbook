provider "aws" {
  region = var.availability_zone
}


resource "aws_vpc" "application_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "App_vpc"
  }
}

resource "aws_subnet" "priv_sub" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "Application_subnet_priv"
  }
}


