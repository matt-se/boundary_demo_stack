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

##### Security group for vault server
resource "aws_security_group" "sg_vault_server" {
  name   = "${var.app_prefix}_vault_serv_sg_${var.environment}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_worker.id]
  }
  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_worker.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




######Boundary config

resource "boundary_host_static" "vault_server_1" {
  name            = "${var.app_prefix}_vault_${var.environment}_1"
  description     = "vault server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.vault.private_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_instance.vault
  ] 
}


resource "boundary_host_set_static" "vault_servers" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  name = "vault_servers"
  host_ids = [
    boundary_host_static.vault_server_1.id
  ]
  depends_on = [
    aws_instance.vault
  ]
}


resource "boundary_target" "vault_ssh" {
  name         = "vault_instance_api_${var.environment}_target"
  description = "for shell access to the vault ec2 instances"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.vault_servers.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.web_server_key.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
}

resource "boundary_target" "vault_api" {
  name         = "vault_instance_shell_${var.environment}_target"
  type         = "tcp"
  default_port = "8200"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.vault_servers.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
}
