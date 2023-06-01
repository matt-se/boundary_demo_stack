
#resource "aws_key_pair" "key_for_ssh_acccess_to_downstream_worker" {
#  key_name   = "${var.app_prefix}_boundary_pki_downstream_worker_${var.environment}_keypair"
#  public_key = data.vault_generic_secret.keys.data["public"]
#}

resource "aws_instance" "boundary__downstream_worker" {
  ami           = var.worker_ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_for_ssh_acccess_to_worker.key_name
  subnet_id     = aws_subnet.subnet_private.id
  vpc_security_group_ids      = [aws_security_group.sg_downstream_worker.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.app_prefix}_boundary_pki_downstream_worker_${var.environment}"
    owner = var.owner
    version = var.app_version
  }
  
  connection {
      type        = "ssh"
      user        = var.worker_key_user
      private_key = file(var.worker_private_key)
      host        = self.public_ip
    }
}


###### Security Group for Worker ######
resource "aws_security_group" "sg_downstream_worker" {
  name   = "${var.app_prefix}_worker_downstream)sg_${var.environment}"
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
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sg_worker.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}