

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
  }
}

resource "aws_subnet" "priv_sub_b"{
    vpc_id = aws_vpc.application_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-north-1b"
    tags = {
        Name = "Application_subnet_priv-b"
    }
}

resource "aws_security_group" "eks_security_group" {
    vpc_id = aws_vpc.application_vpc.id
    name   = "eks_security_group"
}

resource "aws_security_group_rule" "egress_rule" {
  security_group_id = aws_security_group.eks_security_group.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_rule" {
  security_group_id = aws_security_group.eks_security_group.id
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [aws_vpc.application_vpc.cidr_block]
}