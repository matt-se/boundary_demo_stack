
provider "boundary" {
  addr                            = var.boundary_url
  auth_method_id                  = var.boundary_auth_id
  password_auth_method_login_name = var.boundary_username
  password_auth_method_password   = var.boundary_password
}



resource "boundary_scope" "org" {
  name                     = "external_it_services"
  description              = "Products meant for external consumption"
  scope_id                 = "268a4142-1c7f-4c69-af02-853ba8557247"
  auto_create_admin_role   = true
  auto_create_default_role = true
}