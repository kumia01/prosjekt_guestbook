

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.application_vpc.id

    route = [
        {
        cidr_block                 = "0.0.0.0/0"
        nat_gateway_id             = aws_nat_gateway.nat.id
        carrier_gateway_id         = null
        destination_prefix_list_id = null
        egress_only_gateway_id     = null
        gateway_id                 = null
        instance_id                = null
        ipv6_cidr_block            = null
        local_gateway_id           = null
        network_interface_id       = null
        transit_gateway_id         = null
        vpc_endpoint_id            = null
        vpc_peering_connection_id  = null
        core_network_arn           = null
        },
    ]

    tags = {
        Name = "private"
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.application_vpc.id

  route = [
    {
    cidr_block                 = "0.0.0.0/0"
    gateway_id                 = aws_internet_gateway.igw.id
    nat_gateway_id             = null
    carrier_gateway_id         = null
    destination_prefix_list_id = null
    egress_only_gateway_id     = null
    instance_id                = null
    ipv6_cidr_block            = null
    local_gateway_id           = null
    network_interface_id       = null
    transit_gateway_id         = null
    vpc_endpoint_id            = null
    vpc_peering_connection_id  = null
    core_network_arn           = null
    },
  ]

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "private-eu-north-1a" {
    subnet_id = aws_subnet.priv_sub_a.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-north-1b"{
    subnet_id = aws_subnet.priv_sub_a.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-eu-north-1a" {
  subnet_id      = aws_subnet.public-eu-north-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-north-1b" {
  subnet_id      = aws_subnet.public-eu-north-1b.id
  route_table_id = aws_route_table.public.id
}