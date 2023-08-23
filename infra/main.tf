
module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"

    cluster_name = "application_cluster"
    cluster_version = "1.27"

    cluster_endpoint_public_access  = true


      cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

    vpc_id = aws_vpc.application_vpc.id
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]
    control_plane_subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]

    eks_managed_node_group_defaults = {
        instance_type  = "t3.micro"
        ami_type       = "AL2_x86_64"

        attach_cluster_primary_security_group = true
    }

    eks_managed_node_groups = {
        worker_node = {
            min_size = 1
            max_size = 2
            desired_size = 1
            
            instance_type = ["t3.micro"]
            capacity_type = "SPOT"
        }
    }
}




