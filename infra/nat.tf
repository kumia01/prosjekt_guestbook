resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "nat" {
    domain = "vpc"
    
    tags = {
        Name = "nat"
    }
}

resource "aws_nat_gateway" "nat"{
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public-eu-north-1a.id

    tags = {
        Name = "nat"
    }

    depends_on = [aws_internet_gateway.igw]
}