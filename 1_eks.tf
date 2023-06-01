resource "aws_iam_role" "eks-iam-role" {
 name = "eks_iam_role_${var.app_prefix}_${var.environment}"

 path = "/"

 assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}


resource "aws_eks_cluster" "eks_cluster" {
 name     = "${var.app_prefix}-eks-cluster-${var.environment}"
 role_arn = aws_iam_role.eks-iam-role.arn
 vpc_config {
  subnet_ids = [aws_subnet.subnet_public.id, aws_subnet.subnet_public2.id]
 }
 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}


resource "aws_iam_role" "workernodes" {
  name = "eks-node-group-example"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.workernodes.name
 }




 resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks_workernodes_${var.environment}_${var.app_prefix}"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = [aws_subnet.subnet_public.id, aws_subnet.subnet_public2.id]
  instance_types = ["t2.micro"]
 
  scaling_config {
   desired_size = 3
   max_size   = 3
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }




resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks_cluster_sg_${var.app_prefix}_${var.environment}"
  description = "EKS Cluster Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



####### Boundary host and target config ########
#boundary host for eks
resource "boundary_host_static" "eks_server" {
  name            = "${var.app_prefix}_eks_${var.environment}"
  description     = "eks server for ${var.app_prefix} in ${var.environment}"
  address         = aws_eks_cluster.eks_cluster.endpoint
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_eks_cluster.eks_cluster 
  ]
}

#boundary target for eks
resource "boundary_target" "eks_server" {
  name              = "${var.app_prefix}_eks_${var.environment}"
  description       = "eks server for ${var.app_prefix} in ${var.environment}"
  type              = "kubernetes"
  scope_id          = boundary_scope.project.id
  #host_catalog_id   = boundary_host_catalog_static.us_east_1_dev.id
  #target_catalog_id = boundary_target_catalog_static.us_east_1_dev.id

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
  #config = {
  #  kube_config = base64encode(aws_eks_cluster.eks_cluster.kubeconfig)
  #}
}