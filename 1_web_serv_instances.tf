resource "aws_key_pair" "key_for_ssh_acccess_to_web_server" {
  key_name   = "${var.app_prefix}_web_server_${var.environment}_keypair"
  public_key = var.ec2_public_key
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_amazon_linux.id
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
  ami           = data.aws_ami.latest_amazon_linux.id
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



##### boundary config for web servers
resource "boundary_host_static" "web_server" {
  name            = "${var.app_prefix}_web_${var.environment}"
  description     = "frontend web server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.web.private_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_instance.web
  ]
}

resource "boundary_host_static" "web_server_2" {
  name            = "${var.app_prefix}_web_${var.environment}_2"
  description     = "frontend web server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.web2.private_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_instance.web
  ]
}

resource "boundary_host_set_static" "web_servers" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  name = "web_servers"
  host_ids = [
    boundary_host_static.web_server.id,
    boundary_host_static.web_server_2.id
  ]
  depends_on = [
    aws_instance.web
  ]
}

resource "boundary_target" "web" {
  name         = "${var.app_prefix}_${var.environment}_web_servers_remote_access"
  #description  = "Foo target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.web_servers.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.web_server_key.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
}


resource "boundary_credential_store_static" "web_server_certs" {
  name        = "cred store for web servers ${var.environment}"
  description = "My first static credential store!"
  scope_id    = boundary_scope.project.id
}

resource "boundary_credential_ssh_private_key" "web_server_key" {
  name                   = "ssh_private_key"
  description            = "My first ssh private key credential!"
  credential_store_id    = boundary_credential_store_static.web_server_certs.id
  username               = var.web_server_user
  private_key            = var.ec2_private_key
  #private_key_passphrase = "optional-passphrase"
}




##### SECURITY GROUP
resource "aws_security_group" "sg_web_server" {
  name   = "${var.app_prefix}_web_serv_sg_${var.environment}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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




######## Output
output "web_instance_id" {
  value = aws_instance.web.id
}

