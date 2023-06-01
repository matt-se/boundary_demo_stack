resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.app_prefix}_vpc_${var.environment}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_prefix}_igw_${var.environment}"
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.app_prefix}_subnet_${var.environment}"
  }
}

resource "aws_subnet" "subnet_public2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet2
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.app_prefix}_subnet_2_${var.environment}"
  }
}


resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_private_subnet
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.app_prefix}_subnet_private_${var.environment}"
  }
}


resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_prefix}_rtb_public_${var.environment}"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_prefix}_rtb_private_${var.environment}"
  }
}



resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "rta_subnet_public2" {
  subnet_id      = aws_subnet.subnet_public2.id
  route_table_id = aws_route_table.rtb_public.id
}


resource "aws_route_table_association" "rta_subnet_private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.rtb_private.id
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