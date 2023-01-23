resource "aws_instance" "web" {
  ami           = var.web_ami
  instance_type = "t2.micro"
  #key_name      = aws_key_pair.key_for_ssh_acccess_to_worker.key_name
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_web_server.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.app_prefix}_web_${var.environment}"
    owner = var.owner
    version = var.app_version
  }
}