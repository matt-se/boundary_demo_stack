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


variable "tfc_workspace" {
  default     = "dales-dead-bug-web-server-prod"
}

variable "tfc_org" {
  default     = "mattygrecgrec"
}

