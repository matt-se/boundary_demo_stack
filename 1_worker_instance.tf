resource "aws_key_pair" "key_for_ssh_acccess_to_worker" {
  key_name   = "${var.app_prefix}_boundary_pki_worker_${var.environment}_keypair"
  public_key = var.ec2_public_key
}

resource "aws_instance" "boundary_worker" {
  ami           = var.worker_ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_for_ssh_acccess_to_worker.key_name
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_worker.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.app_prefix}_boundary_pki_worker_${var.environment}"
    owner = var.owner
    version = var.app_version
  }
  user_data_replace_on_change = true
  user_data = templatefile("install_boundary.sh", {
    boundary_cluster_id = var.boundary_cluster_id,
    controller_generated_activation_token = boundary_worker.worker.controller_generated_activation_token
  })

  connection {
      type        = "ssh"
      user        = var.worker_key_user
      private_key = var.ec2_private_key
      host        = self.public_ip
    }
}



###### Security Group for Worker ######
resource "aws_security_group" "sg_worker" {
  name   = "${var.app_prefix}_worker_sg_${var.environment}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 9202
    to_port     = 9202
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#################### HCP Boundary configuration ####################
resource "boundary_worker" "worker" {
  name        = "${var.app_prefix}_worker_${var.environment}"
  description = "${var.app_prefix}_worker_${var.environment}"
  scope_id    = "global"
}



############## Outputs ##############
output "boundary_worker_reg_code" {
  value = boundary_worker.worker.controller_generated_activation_token
}