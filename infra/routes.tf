

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.application_vpc.id

    route = [
        {
        cidr_block                 = "0.0.0.0/0"
        carrier_gateway_id         = ""
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = ""
        instance_id                = ""
        ipv6_cidr_block            = ""
        local_gateway_id           = ""
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
        },
    ]

    tags = {
        Name = "private"
    }
}

resource "aws_route_table_association" "private-eu-north-1-a" {
    subnet_id = aws_subnet.priv_sub_a.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-north-1-b"{
    subnet_id = aws_subnet.priv_sub_a.id
    route_table_id = aws_route_table.private.id
}