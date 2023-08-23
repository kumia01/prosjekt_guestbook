
module "eks" {
    source = "terraform-aws-modules/eks/aws"
    cluster_name = "my_cluster"
    cluster_version = "1.21"
    subnets = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]

    node_groups = {
        eks_nodes= {
            desired_capacity = 1
            max_capacity = 2
            min_capacity = 1

            instance_type = "t2.micro"
            key_name = var.key_name
        }
    }
}



