
resource "aws_eip" "nat" {
    vpc = true
}

resource "aws_nat_gateway" "eks_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public-eu-north-1a.id
    depends_on    = [aws_subnet.public-eu-north-1a]
}