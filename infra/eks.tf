
resource "aws_iam_role" "eks_cluster_role" {
    name = "eks_cluster_role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
            Effect = "Allow",
            Principal = {
                Service = "eks.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "application_cluster" {
  name = "app_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.priv_sub_a.id,
      aws_subnet.priv_sub_b.id,
      aws_subnet.public-eu-north-1a.id,
      aws_subnet.public-eu-north-1b.id
      ]
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

