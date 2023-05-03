mkdir /home/ubuntu/boundary/ && cd /home/ubuntu/boundary/
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install boundary-worker-hcp -y
sudo touch /home/ubuntu/boundary/pki-worker.hcl

printf "contents of hcl config file" | sudo tee pki-worker.hcl
boundary-worker server -config="/home/ubuntu/boundary/pki-worker.hcl"
