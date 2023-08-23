


resource "aws_eks_cluster" "application_cluster" {
  name = "app_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_eks_node_group" "worker_nodes" {
    cluster_name = aws_eks_cluster.application_cluster.name
    node_group_name = "my-worker-group"
    node_role_arn = aws_iam_role.eks_worker.name
    subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]

    scaling_config {
        desired_size = 1
        max_size = 3
        min_size = 1
    }

    instance_types = ["m5.large"]
    ami_type = "AL2_x86_64"

    depends_on = [
        aws_iam_role_policy_attachment.eks_worker_eks_policy,
        aws_iam_role_policy_attachment.eks_worker_cni_policy,
        aws_iam_role_policy_attachment.eks_worker_ecr_policy,
        aaws_iam_role_policy_attachment.eks_worker_custom_policy
    ]
}