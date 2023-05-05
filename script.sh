#!/bin/bash

set -e
exec >/var/log/logfile.txt 2>&1


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