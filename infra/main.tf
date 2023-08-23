


resource "aws_eks_cluster" "application_cluster" {
  name = "app_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_launch_configuration" "eks_worker" {
    name_prefix = "eks-worker"
    instance_type = "t2.micro"
    iam_instance_profile = aws_iam_instance_profile.eks_worker_instance_profile.name
    image_id = "ami-07bfff1c04cd9d7bd"

}

resource "aws_launch_template" "eks_worker" {
  name_prefix   = "worker"
  image_id      = "ami-07bfff1c04cd9d7bd" # Your AMI ID
  instance_type = "m5.large"

  user_data = base64encode(<<-EOT 
                #!/bin/bash
                /etc/eks/bootstrap.sh ${aws_eks_cluster.application_cluster.name}
                EOT
                )
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
