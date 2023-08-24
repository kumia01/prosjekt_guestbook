
resource "aws_eip" "nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "eks_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public-eu-north-1a.id
    depends_on    = [aws_subnet.public-eu-north-1a]
}

#internett gateway

resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name = "App_IGW"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public-eu-north-1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public-eu-north-1b.id
  route_table_id = aws_route_table.public_route_table.id
}
