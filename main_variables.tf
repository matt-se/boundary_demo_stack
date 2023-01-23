variable "region" {
  description = "The region Terraform deploys your instance"
  default     = "us-east-1"
}

variable "app-prefix" {
  description = "prefix of the app that will be created in AWS"
  default     = "dales-dead-bug-web-server-prod"
}


variable "environment_tag" {
  description = "Environment tag"
  default     = "dev"
}


variable "tfc-workspace" {
  default     = "dales-dead-bug-web-server-prod"
}

variable "tfc-org" {
  default     = "mattygrecgrec"
}

