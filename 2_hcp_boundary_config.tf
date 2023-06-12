#################### scopes
resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  name                     = "External IT Services"
  description              = "Products meant for external consumption"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "project" {
  name                   = "aws"
  description            = "AWS resources for external IT services"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
}

resource "boundary_scope" "org_internal" {
  name                     = "Internal IT Services"
  description              = "Products meant for INTERNAL consumption"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "org_backend" {
  name                     = "Backend Infrastructure"
  description              = "Backend Underlying Infrastructure"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}


/*
resource "boundary_credential_store_vault" "vault-aws" {
  name        = "vault-aws"
  description = "My first Vault credential store!"
  address     = var.vault_url
  token       = var.vault_token
  scope_id    = boundary_scope.project.id
  namespace   = "admin"
}
resource "boundary_credential_library_vault" "vault-aws" {
  name                = "get-aws-iam-creds"
  description         = "My first Vault credential library!"
  credential_store_id = boundary_credential_store_vault.vault-aws.id
  path                = "aws/creds/vault-demo-iam-user"
  http_method         = "GET"
}
*/


####################  host catalog
resource "boundary_host_catalog_static" "us_east_1_dev" {
  name        = "us-east-1-dev"
  description = "Dev AWS resources in us-east-1"
  scope_id    = boundary_scope.project.id
}



### dummy for SSM
resource "boundary_host_static" "ssm" {
  name            = "${var.app_prefix}_ssm_${var.environment}"
  description     = "ssm for ${var.app_prefix} in ${var.environment}"
  address         = "127.0.0.1"
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
}

resource boundary_host_set_static "ssm" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  name = "ssm"
  host_ids = [
    boundary_host_static.ssm.id
  ]
}

resource "boundary_target" "ssm" {
  name         = "ssm_remote_access"
  type         = "tcp"
  default_port = "9999"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.ssm.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
  #brokered_credential_source_ids = [
  #  boundary_credential_library_vault.vault-aws.id
  #]
}


#################### users
resource "boundary_auth_method" "password" {
  name     = "unpw_auth_method"
  scope_id = boundary_scope.org.id
  type     = "password"
}

resource "boundary_account_password" "bobby-hill" {
  auth_method_id = boundary_auth_method.password.id
  type           = "password"
  login_name     = var.boundary_lower_user_name
  password       = var.boundary_lower_user_password
}

resource "boundary_user" "bobby-hill" {
  name        = "bobby-hill"
  description = "bobby-hill's user resource"
  account_ids = [boundary_account_password.bobby-hill.id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_group" "external_it_services_devs" {
  name        = "external_it_services_devs"
  description = "external_it_services_devs"
  member_ids  = [boundary_user.bobby-hill.id]
  scope_id    = boundary_scope.org.id
}


resource "boundary_role" "devs_read_only" {
  name        = "devs_read_only"
  description = "My first role!"
  principal_ids = [
    boundary_group.external_it_services_devs.id
  ]
  scope_id    = boundary_scope.project.id
  grant_strings = ["id=*;type=target;actions=list,read,authorize-session","id=*;type=session;actions=read:self,cancel:self","id=*;type=session;actions=no-op,list"]
}



#################### workers
resource "boundary_worker" "worker" {
  name        = "${var.app_prefix}_worker_${var.environment}"
  description = "${var.app_prefix}_worker_${var.environment}"
  scope_id    = "global"
}

resource "boundary_worker" "downstream_worker" {
  name        = "${var.app_prefix}_downstream_worker_${var.environment}"
  description = "${var.app_prefix}_downstream_worker_${var.environment}"
  scope_id    = "global"
}



############## Outputs ##############
output "boundary_worker_reg_code" {
  value = boundary_worker.worker.controller_generated_activation_token
}

output "boundary_worker_downstream_reg_code" {
  value = boundary_worker.downstream_worker.controller_generated_activation_token
}