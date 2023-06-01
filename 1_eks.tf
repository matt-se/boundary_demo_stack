resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.app_prefix}-eks-cluster-${var.environment}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.eks_subnet.id]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role_${var.app_prefix}_${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks_cluster_sg_${var.app_prefix}_${var.environment}"
  description = "EKS Cluster Security Group"
  vpc_id      = aws_vpc.eks_vpc.id
}

resource "aws_security_group_rule" "eks_cluster_ingress" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group_${var.app_prefix}_${var.environment}"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  remote_access {
    ec2_ssh_key = "my-ec2-key"
    source_security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  subnet_ids = [aws_subnet.subnet_public.id]
}

output "kubeconfig" {
  value = aws_eks_cluster.eks_cluster.kubeconfig
}