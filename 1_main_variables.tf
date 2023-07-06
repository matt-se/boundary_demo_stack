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
  default     = "https://7d10cc4a-64b4-4cb1-a29a-2fbe566e5df7.boundary.hashicorp.cloud"
}
variable "boundary_cluster_id" {
  default     = "7d10cc4a-64b4-4cb1-a29a-2fbe566e5df7"
}
variable "boundary_auth_id" {
  default     = "ampw_vxuhHlAIUA"
  description = "get this from boundary.  It is the root auth method"
}
variable "boundary_username" {
  default     = "matty-boundary-admin"
  description = "admin user for boundary"
}
variable "boundary_password" {}
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
variable "ec2_public_key" {}
variable "ec2_private_key" {}
/*
variable "web_server_public_key" {}
variable "web_server_private_key" {}
variable vault_public_key {}
variable "vault_private_key" {}
variable "worker_public_key" {}
variable "worker_private_key" {}
variable "windows_public_key" {}
*/

variable "web_server_user" {
  default       = "ec2-user"
}

##########   AWS worker instance
variable "worker_ami" {
  description = "ami to use for the worker instance"
  default     = "ami-00874d747dde814fa"
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

########## Vault Provider
variable "vault_url" {
  default     = "https://vault-cluster.vault.501b9ee8-edcc-45af-ab0a-21f84404f1b4.aws.hashicorp.cloud:8200"
}

variable "vault_token" {
  default = "sfsdfsdfsdf"
}