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
