# Get latest Windows Server 2022 AMI
data "aws_ami" "windows-2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}


resource "aws_key_pair" "key_for_ssh_acccess_to_windows_server" {
  key_name   = "${var.app_prefix}_windows_${var.environment}_keypair"
  public_key = file(var.windows_path_to_public_key)
}


resource "aws_instance" "windows" {
  ami           = data.aws_ami.windows-2022
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public.id
  key_name = aws_key_pair.key_for_ssh_acccess_to_windows_server.key_name
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
      private_key = file(var.windows_path_to_private_key)
      host        = self.public_ip
    }
}