#################### scopes
resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  name                     = "external_it_services"
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


####################  creds
resource "boundary_credential_store_static" "web_server_certs" {
  name        = "cred store for web servers ${var.environment}"
  description = "My first static credential store!"
  scope_id    = boundary_scope.project.id
}

resource "boundary_credential_ssh_private_key" "web_server_key" {
  name                   = "ssh_private_key"
  description            = "My first ssh private key credential!"
  credential_store_id    = boundary_credential_store_static.web_server_certs.id
  username               = var.web_server_user
  private_key            = var.web_server_private_key
  #private_key_passphrase = "optional-passphrase"
}

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











####################  hosts
resource "boundary_host_catalog_static" "us_east_1_dev" {
  name        = "us-east-1-dev"
  description = "Dev AWS resources in us-east-1"
  scope_id    = boundary_scope.project.id
}


resource "boundary_host_static" "web_server" {
  name            = "${var.app_prefix}_web_${var.environment}"
  description     = "frontend web server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.web.private_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_instance.web
  ]
}

resource "boundary_host_static" "web_server_2" {
  name            = "${var.app_prefix}_web_${var.environment}_2"
  description     = "frontend web server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.web2.private_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  depends_on = [
    aws_instance.web
  ]
}

resource "boundary_host_set_static" "web_servers" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  name = "web_servers"
  host_ids = [
    boundary_host_static.web_server.id,
    boundary_host_static.web_server_2.id
  ]
  depends_on = [
    aws_instance.web
  ]
}

resource "boundary_target" "web" {
  name         = "web_servers_remote_access"
  #description  = "Foo target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.web_servers.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.web_server_key.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
}


### RDS host
resource "boundary_host_static" "rds" {
  name            = "${var.app_prefix}_rds_${var.environment}"
  description     = "dB for ${var.app_prefix} in ${var.environment}"
  address         = aws_db_instance.db.address
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
}

resource boundary_host_set_static "rds" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  name = "rds"
  host_ids = [
    boundary_host_static.rds.id
  ]
}

resource "boundary_target" "db" {
  name         = "rds_remote_access"
  type         = "tcp"
  default_port = "5432"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.rds.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
}



### windows
resource "boundary_host_static" "win_server" {
  name            = "${var.app_prefix}_win_${var.environment}"
  description     = "windows server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.windows.private_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
}

resource boundary_host_set_static "win_servers" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  name = "win_servers"
  host_ids = [
    boundary_host_static.win_server.id
  ]
}

resource "boundary_target" "win" {
  name         = "win_remote_access"
  type         = "tcp"
  default_port = "3389"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.win_servers.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
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
  brokered_credential_source_ids = [
    boundary_credential_library_vault.vault-aws.id
  ]
}







#################### users
resource "boundary_auth_method" "password" {
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