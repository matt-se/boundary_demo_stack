
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
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}