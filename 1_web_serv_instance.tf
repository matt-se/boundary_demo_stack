resource "aws_key_pair" "key_for_ssh_acccess_to_web_server" {
  key_name   = "${var.app_prefix}_web_server_${var.environment}_keypair"
  public_key = file(var.web_server_public_key)
}


resource "aws_instance" "web" {
  ami           = var.web_ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_for_ssh_acccess_to_web_server.key_name
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_web_server.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.app_prefix}_web_${var.environment}"
    owner = var.owner
    version = var.app_version
  }
}

resource "aws_instance" "web2" {
  ami           = var.web_ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_for_ssh_acccess_to_web_server.key_name
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_web_server.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.app_prefix}_web_${var.environment}_2"
    owner = var.owner
    version = var.app_version
  }
}