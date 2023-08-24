
resource "aws_iam_role" "eks_worker" {
  name = "EKSWorkerPolicy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker.name
}
resource "aws_iam_instance_profile" "eks_worker" {
    name = "eksworker-profile"
    role = aws_iam_role.eks_worker.name
}

resource "aws_eks_node_group" "worker_nodes" {
  cluster_name = aws_eks_cluster.application_cluster.name
  node_group_name = "my-worker-group-1"
  node_role_arn = aws_iam_role.eks_worker.arn
  subnet_ids = [aws_subnet.priv_sub_a.id, aws_subnet.priv_sub_b.id]

  remote_access {
    ec2_ssh_key = "application_key"
  }

  capacity_type = "ON_DEMAND"
  instance_types = ["t3.medium"]

    scaling_config {
        desired_size = 1
        max_size = 3
        min_size = 1
    }

    update_config {
      max_unavailable = 1
    }

    ami_type = "AL2_x86_64"

    depends_on = [
        aws_iam_role_policy_attachment.eks_worker_eks_policy,
        aws_iam_role_policy_attachment.eks_worker_cni_policy,
        aws_iam_role_policy_attachment.eks_worker_ecr_policy
    ]
}