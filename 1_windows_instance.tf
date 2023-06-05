# Get latest Windows Server 2022 AMI
data "aws_ami" "windows-2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}

resource "aws_key_pair" "key_for_windows_server" {
  key_name   = "${var.app_prefix}_win_server_${var.environment}_keypair"
  public_key = var.windows_public_key
}


resource "aws_instance" "windows" {
  ami           = data.aws_ami.windows-2022.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public.id
  key_name = aws_key_pair.key_for_windows_server.key_name
  vpc_security_group_ids      = [aws_security_group.sg_windows.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.app_prefix}_windows_${var.environment}"
    owner = var.owner
    version = var.app_version
  }
  
  connection {
      type        = "winrm"
      #user        = var.windows_key_user
      private_key = var.windows_private_key
      host        = self.public_ip
    }
}


##### security group config for windows server
resource "aws_security_group" "sg_windows" {
  name   = "${var.app_prefix}_windows_sg_${var.environment}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_worker.id]
}
}

### boundary config for windows
resource "boundary_host_static" "win_server" {
  name            = "${var.app_prefix}_win_${var.environment}"
  description     = "windows server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.windows.private_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
}

resource boundary_host_set_static "win_servers" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  name = "win_servers"
  host_ids = [
    boundary_host_static.win_server.id
  ]
}

resource "boundary_target" "win" {
  name         = "${var.app_prefix}_${var.environment}_win_remote_access"
  type         = "tcp"
  default_port = "3389"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.win_servers.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
}