variable "region" {
  description = "The region Terraform deploys your instance"
  default     = "us-east-1"
}

variable "app_prefix" {
  description = "prefix of the app that will be created in AWS"
  default     = "dales-dead-bug_frontend"
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


variable "tfc_workspace" {
  default     = "dales-dead-bug-web-server-prod"
}

variable "tfc_org" {
  default     = "mattygrecgrec"
}

variable "boundary_url" {
  default     = "https://268a4142-1c7f-4c69-af02-853ba8557247.boundary.hashicorp.cloud"
}

variable "boundary_auth_id" {
  default     = "ampw_e9LKix24m6"
}


variable "boundary_username" {
  default     = "matty-boundary-admin"
}

variable "boundary_password" {
  default     = "changeme"
}