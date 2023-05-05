resource "aws_key_pair" "key_for_ssh_acccess_to_worker" {
  key_name   = "${var.app_prefix}_boundary_pki_worker_${var.environment}_keypair"
  public_key = var.worker_public_key
}

#data "template_file" "user_data" {
#  template = file("config.yaml")
#}



resource "aws_instance" "boundary_worker" {
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
  user_data_replace_on_change = true
  user_data = "${file("script.sh")}"
  
  /*
  user_data   = <<-EOF
        mkdir /home/ubuntu/boundary/ && cd /home/ubuntu/boundary/
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        sudo apt-get update && sudo apt-get install boundary-worker-hcp -y
        sudo touch /home/ubuntu/boundary/pki-worker.hcl

        printf "disable_mlock = true
        hcp_boundary_cluster_id = "${var.boundary_cluster_id}"
        listener "tcp" {
          address = "0.0.0.0:9202"
          purpose = "proxy"
        }
                
        worker {
          public_addr = "44.201.8.40"
          controller_generated_activation_token = "${boundary_worker.worker.controller_generated_activation_token}"
          auth_storage_path = "home/ubuntu/boundary/worker1"
          tags {
            type = ["worker"]
          }
        }" | sudo tee pki-worker.hcl
        boundary-worker server -config="/home/ubuntu/boundary/pki-worker.hcl"
        EOF
*/
  
  connection {
      type        = "ssh"
      user        = var.worker_key_user
      private_key = var.worker_private_key
      host        = self.public_ip
    }
}