#resource "aws_key_pair" "key_for_ssh_acccess_to_web_server" {
#  key_name   = "${var.app_prefix}_web_server_${var.environment}_keypair"
#  public_key = var.web_server_public_key
#}

resource "aws_instance" "vault" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_for_ssh_acccess_to_web_server.key_name
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_vault_server.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.app_prefix}_vault_${var.environment}"
    owner = var.owner
    version = var.app_version
  }
}