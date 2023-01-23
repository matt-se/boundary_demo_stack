provider "boundary" {
  addr                            = var.boundary_url
  auth_method_id                  = var.boundary_auth_id
  password_auth_method_login_name = var.boundary_username
  password_auth_method_password   = var.boundary_password
}

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
  depends_on = [
    aws_instance.web
  ]
  name            = "${var.app_prefix}_web_${var.environment}"
  description     = "frontend web server for ${var.app_prefix} in ${var.environment}"
  address         = aws_instance.web.public_ip
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  #scope_id        = boundary_scope.project.id
}

resource "boundary_host_set_static" "web_servers" {
  host_catalog_id = boundary_host_catalog_static.us_east_1_dev.id
  host_ids = [
    boundary_host_static.web_server.id
  ]
}