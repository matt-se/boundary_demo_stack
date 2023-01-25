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
  default     = "https://e9ac2d61-1eda-44e8-9d86-e456659b8bf7.boundary.hashicorp.cloud"
}

variable "boundary_auth_id" {
  default     = "ampw_DOlloiL9SB"
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
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.1.0/24"
}
variable "cidr_subnet2" {
  description = "CIDR block for the subnet"
  default     = "10.1.2.0/24"
}


##########   AWS web servers variables
variable "web_ami" {
  description = "ami to use for the web instance"
  default     = "ami-00874d747dde814fa"
}

variable "web_server_public_key" {
  default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOi/5ltdmHwW9xBnfpYHghuvQum4hQrAEjFjbPlI9fdqGk2deCHi5yr7llKslAtbeeEqpx8DI9aBUoTnw9kapDue03jFpWG9yLItqXElkMD5Ft2BAfXgwqVtntpt1h3n4mTLHj1Z6GNnLdLbpTA+3HabyU12TZ5x3vinZ0H0kOq9Spt1hCW6F1PUf+KRR6BQ/q78tPZL75rcY4d/rkF4lqS2Q/SatYGxsZCV/P/ScmBCKRrJIMDCD/q5tMFi1p2sGEdpvUci7ZfiC13mVsWI52v5HxGXqkcuZm6NWJCA8g+yjzr7nCKHz0MrUDvxwidg8TtNrvtaM0r61h+HcLL6QP"
}

variable "web_server_path_to_private_key" {
  default       = "dales-dead-bug_frontend_web_server_dev_keypair.pem"
}

variable "web_server_user" {
  default       = "ubuntu"
}



##########   AWS worker instance
variable "worker_ami" {
  description = "ami to use for the worker instance"
  default     = "ami-00874d747dde814fa"
}

variable "public_key" {
  default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCLi9c5+rSxHcPFBEwpRAlLNug4eDXCbeu8KSqsRZLvEW3MJZOtTwyMKpBp77QeK23YhX9CeKbOGvb7+GajXWHH85L7MVrZ7BSa9iSMDhlUJpgBjglNMe8UqXpxgajII5VyFbQog0dfo++GJ39uufPYzlrZ1w+M7g8psf9uELXAB97/srBPkjc45Lq+WNkeuIGyHHP4GgeWQyxUWc2619/2r/V91l5QnqQGAXDzP2qsvM/XV2iYEm3L/bngj2JkOAC0m1k/vm7g//FQzvQ3eAjA8Sz7XERZ+79+GWsbq8x/wmrMAGZvyCzgx17Op95R9BKH5xFj1F5axMPRl0LzgpoL"
}

variable "path_to_private_key" {
  default       = "key.pem"
}

variable "worker_key_user" {
  default       = "ubuntu"
}