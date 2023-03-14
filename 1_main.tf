terraform {
  backend "remote" {
    organization = var.tfc_org
    workspaces {
      name = var.tfc_workspace
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}


provider "aws" {
  region = var.region
}


provider "boundary" {
  addr                            = var.boundary_url
  auth_method_id                  = var.boundary_auth_id
  password_auth_method_login_name = var.boundary_username
  password_auth_method_password   = var.boundary_password
}

provider "vault" {}





data "vault_generic_secret" "keys" {
  path = "secret/aws-keys"
}
output "mypassword" {
 value = "${data.vault_generic_secret.key.data["public"]}"
}