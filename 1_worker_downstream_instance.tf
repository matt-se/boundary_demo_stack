
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
      private_key = file(var.worker_path_to_private_key)
      host        = self.public_ip
    }
}


