variable "region" {
  description = "The region Terraform deploys your instance"
  default     = "us-east-1"
}

variable "app_prefix" {
  description = "prefix of the app that will be created in AWS"
  default     = "dales-dead-bug-frontend"
}

variable "environment" {
  description = "Environment tag"
  default     = "dev"
}

variable "owner" {
  default     = "mattygrecgrec"
}

variable "app_version" {
  default     = "0.1"
}

######### TFC
variable "tfc_workspace" {
  default     = "dales-dead-bug-web-server-prod"
}

variable "tfc_org" {
  default     = "mattygrecgrec"
}


#########  HCP Boundary
variable "boundary_url" {
  default     = "https://98814fc9-b650-4469-96c0-5397232f19b1.boundary.hashicorp.cloud"
}

variable "boundary_cluster_id" {
  default     = "98814fc9-b650-4469-96c0-5397232f19b1"
}

variable "boundary_auth_id" {
  default     = "ampw_s06oRsCdpU"
}


variable "boundary_username" {
  default     = "matty-boundary-admin"
}

variable "boundary_password" {
  default     = "changeme"
}

variable "boundary_lower_user_name" {
  default     = "bobby-hill"
}

variable "boundary_lower_user_password" { 
  default     = "changeme"
}


##########  AWS networking
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.0.0.0/24"
}
variable "cidr_subnet2" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "cidr_private_subnet" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

##########   AWS web servers variables
variable "web_ami" {
  description = "ami to use for the web instance"
  default     = "ami-00874d747dde814fa"
}

variable "web_server_public_key" {
#  default       = "keys/dales-dead-bug_frontend_web_server_dev_keypair.pem.pub"
}

variable "web_server_private_key" {
  #default       = "keys/dales-dead-bug_frontend_web_server_dev_keypair.pem"
}

variable "web_server_user" {
  default       = "ec2-user"
}

variable vault_public_key {
}

variable "vault_private_key" {
}
  

##########   AWS worker instance
variable "worker_ami" {
  description = "ami to use for the worker instance"
  default     = "ami-00874d747dde814fa"
}

variable "worker_public_key" {
 # default       = "keys/dales-dead-bug_frontend_boundary_pki_worker_dev_keypair.pem.pub"
}

variable "worker_private_key" {
  #default       = "keys/dales-dead-bug_frontend_boundary_pki_worker_dev_keypair.pem"
}

variable "worker_key_user" {
  default       = "ubuntu"
}



##########   AWS database
variable "aws_rds_username" {
  default     = "matty"
}
  
variable "aws_rds_password" {
  default     = "passwordpassword123"
}


##########   AWS windows instance
variable "windows_ami" {
  description = "ami to use for the windows instance"
  default     = "ami-03cf1a25c0360a382"
}

variable "windows_public_key" {
  #default       = "keys/dales-dead-bug_frontend_windows_dev_keypair.pem.pub"
}

########## Vault Provider
variable "vault_url" {
  default     = "https://vault-cluster.vault.501b9ee8-edcc-45af-ab0a-21f84404f1b4.aws.hashicorp.cloud:8200"
}

variable "vault_token" {
  default = "sfsdfsdfsdf"
}