
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

resource "boundary_host_set_static" "web_servers" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  host_ids = [
    boundary_host_static.web_server.id
  ]
  depends_on = [
    aws_instance.web
  ]
}


resource "boundary_auth_method" "password" {
  scope_id = boundary_scope.org.id
  type     = "password"
}

resource "boundary_account_password" "bobby-hill" {
  auth_method_id = boundary_auth_method.password.id
  type           = "password"
  login_name     = "bobby-hill"
  password       = "$uper$ecure"
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
  scope_id    = boundary_scope.project.id
}

resource "boundary_role" "devs_read_only" {
  name        = "devs_read_only"
  description = "My first role!"
  principal_ids = [
    boundary_group.external_it_services_devs.id
  ]
  scope_id    = boundary_scope.org.id
  grant_strings = ["id=*;type=*;actions=read"]
}


resource "boundary_worker" "worker" {
  name        = "${var.app_prefix}_worker_${var.environment}}"
  description = "${var.app_prefix}_worker_${var.environment}}"
  scope_id    = "global"
}