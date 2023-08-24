

resource "aws_vpc" "application_vpc" {
  cidr_block = "10.0.0.0/16"
    
  tags = {
    Name = "App_vpc"
  }
}


resource "aws_subnet" "priv_sub_a" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "Application_subnet_priv-a"
    "kubernetes.oi/role/internal-elb" = "1"
    "kubernetes.oi/cluster/app_cluster" = "owned"
  }
}

resource "aws_subnet" "priv_sub_b"{
    vpc_id = aws_vpc.application_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-north-1b"
    tags = {
        Name = "Application_subnet_priv-b"
        "kubernetes.oi/role/internal-elb" = "1"
        "kubernetes.oi/cluster/app_cluster" = "owned"
    }
}

resource "aws_subnet" "public-eu-north-1a" {
  vpc_id = aws_vpc.application_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
        Name = "Application_subnet_pub-a"
        "kubernetes.oi/role/internal-elb" = "1"
        "kubernetes.oi/cluster/app_cluster" = "owned"
    }
}

resource "aws_subnet" "public-eu-north-1b" {
  vpc_id = aws_vpc.application_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = true
  tags = {
        Name = "Application_subnet_pub-b"
        "kubernetes.oi/role/internal-elb" = "1"
        "kubernetes.oi/cluster/app_cluster" = "owned"
    }
}

