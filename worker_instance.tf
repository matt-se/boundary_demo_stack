resource "aws_key_pair" "key_for_ssh_acccess_to_worker" {
  key_name   = "${var.app_prefix}_boundary_pki_worker_${var.environment}_keypair}"
  public_key = var.public_key
}

resource "aws_instance" "web" {
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
  
  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.path_to_private_key)
      host        = self.public_ip
    }
}