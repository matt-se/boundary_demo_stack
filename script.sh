#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log) 2>&1

mkdir /home/ubuntu/boundary/ && cd /home/ubuntu/boundary/
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install boundary-worker-hcp -y
sudo touch /home/ubuntu/boundary/pki-worker.hcl

sudo cat > /home/ubuntu/boundary/pki-worker.hcl <<EOF
disable_mlock = true
hcp_boundary_cluster_id = "${boundary_cluster_id}"
listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
        
worker {
  public_addr = $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
  controller_generated_activation_token = "${controller_generated_activation_token}"
  auth_storage_path = "home/ubuntu/boundary/worker1"
  tags {
    type = ["worker"]
  }
}
EOF

boundary-worker server -config="/home/ubuntu/boundary/pki-worker.hcl"