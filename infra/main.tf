
module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"

    cluster_name = "application_cluster"
    cluster_version = "1.27"

    vpc_id = aws_vpc.application_vpc.id
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]

    node_groups = {
        eks_nodes = {
            desired_capacity = 1
            max_capacity = 2
            min_capacity = 1

            instance_type = "t2.micro"
            key_name = var.key_name
        }
    }
}



