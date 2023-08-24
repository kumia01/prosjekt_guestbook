

resource "aws_vpc" "application_vpc" {
  cidr_block = "10.0.0.0/16"
    
  tags = {
    Name = "App_vpc"
  }
}


resource "aws_subnet" "priv_sub_a" {
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "Application_subnet_priv-a"
    "kubernetes.oi/role/internal-elb" = "1"
    "kubernetes.oi/cluster/app_cluster" = "owned"
  }
}

resource "aws_subnet" "priv_sub_b"{
    vpc_id = aws_vpc.application_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-north-1b"
    tags = {
        Name = "Application_subnet_priv-b"
        "kubernetes.oi/role/internal-elb" = "1"
        "kubernetes.oi/cluster/app_cluster" = "owned"
    }
}

resource "aws_security_group" "eks_security_group" {
    vpc_id = aws_vpc.application_vpc.id
    name   = "eks_security_group"
    description = "EKS Control Plane Security Group"
}

resource "aws_security_group" "eks_worker_node_sg" {
  name = "eks-worker-node-sg"
  description = "EKS worker Nodes sg"
  vpc_id = aws_vpc.application_vpc.id
}

resource "aws_security_group_rule" "eks_control_plane_outbound" {
  security_group_id = aws_security_group.eks_security_group.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_nodes_inbound_from_eks_control_plane" {
  security_group_id = aws_security_group.eks_worker_node_sg.id
  type = "ingress"
  from_port = 1025
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = aws_security_group.eks_security_group.id
}

resource "aws_security_group_rule" "worker_node_all_outbound" {
  security_group_id = aws_security_group.eks_worker_node_sg.id
  type = "egress"
  protocol = "-1"
  from_port = 0
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_nodes_inbound_nodeport" {
  security_group_id = aws_security_group.eks_worker_node_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 30000
  to_port           = 32767
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_nodes_inbound_from_self" {
  security_group_id = aws_security_group.eks_worker_node_sg.id
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  source_security_group_id = aws_security_group.eks_worker_node_sg.id
}