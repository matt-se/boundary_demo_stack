/*
data "vault_generic_secret" "keys" {
  path = "secret/aws"
}
output "mypassword" {
 value = data.vault_generic_secret.keys.data["public"]
}
*/

