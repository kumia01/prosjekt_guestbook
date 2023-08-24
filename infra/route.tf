
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_gateway.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.priv_sub_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.priv_sub_b.id
  route_table_id = aws_route_table.private.id
}