
module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"

    cluster_name = "application_cluster"
    cluster_version = "1.27"

    vpc_id = aws_vpc.application_vpc.id
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]
}

eks_managed_node_gorups_defaults = {
        instance_types = ["t2.micro"]
}

eks_managed_node_groups = {
    worker_node = {
        min_size = 1
        max_size = 2
        desired_size = 1
        
        instance_type = ["t2.micro"]
    }
}



