


resource "aws_eks_cluster" "application_cluster" {
  name = "app_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_launch_template" "eks_worker" {

  name_prefix   = "worker"
  image_id      = "ami-07bfff1c04cd9d7bd" # Your AMI ID
  instance_type = "m5.large"

}

resource "aws_autoscaling_group" "eks_worker_group"{
    min_size = 1
    max_size = 2
    desired_capacity = 2
    vpc_zone_identifier = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]
    
    launch_template {
      id = aws_launch_template.eks_worker.id
      version = "$Latest"
    }

    tag {
        key = "Name"
        value = "eks-worker-node"
        propagate_at_launch = true
    }
}

resource "aws_eks_node_group" "worker_nodes" {
    cluster_name = aws_eks_cluster.applications_cluster.name
    node_group_name = "my-worker-group"
    node_role_arn = aws_iam_role.eks_node_role.name
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]

    scaling_config {
        desired_size = 1
        max_size = 3
        min_size = 1
    }

    intance_type = "m5.large"
    ami_type = "ami-02f424f49b600a4ed"

    depends_on = [aws_iam_role_policy_attachment.eks_node_policy]
}