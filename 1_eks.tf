resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.app_prefix}-eks-cluster-${var.environment}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_public.id]
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
  vpc_id      = aws_vpc.vpc.id
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



####### Boundary host and target config ########

#boundary host for eks
resource "boundary_host_static" "eks_server" {
  name            = "${var.app_prefix}_eks_${var.environment}"
  description     = "eks server for ${var.app_prefix} in ${var.environment}"
  address         = aws_eks_cluster.eks.endpoint
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_eks_cluster.eks
  ]
}

#boundary target for eks
resource "boundary_target_static" "eks_server" {
  name            = "${var.app_prefix}_eks_${var.environment}"
  description     = "eks server for ${var.app_prefix} in ${var.environment}"
  type            = "kubernetes"
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  target_catalog_id = boundary_target_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_eks_cluster.eks
  ]
  config = {
    kube_config = base64encode(aws_eks_cluster.eks.kubeconfig)
  }
}