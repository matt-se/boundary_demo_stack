#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log) 2>&1

# Download and install Vault
mkdir /home/ubuntu/vault/ && cd /home/ubuntu/vault/
sudo apt update
sudo apt install unzip
sudo wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
sudo unzip vault_${VAULT_VERSION}_linux_amd64.zip
sudo mv vault /usr/local/bin/
sudo rm -f vault_${VAULT_VERSION}_linux_amd64.zip

# Set the VAULT_ADDR environment variable
export VAULT_ADDR='http://127.0.0.1:8200'

# Start Vault in dev mode with the root token set as 'matt'
nohup vault server -dev -dev-root-token-id="matt" -dev-listen-address="0.0.0.0:8200" &


# It will take some time to start up, sleep for few seconds
sleep 10s

# Verify that Vault is running
vault status

echo "Vault is now running in dev mode."

export VAULT_TOKEN="matt"
vault auth enable userpass
vault write auth/userpass/users/bobby password=password