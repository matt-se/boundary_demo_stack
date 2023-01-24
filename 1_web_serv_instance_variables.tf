variable "web_ami" {
  description = "ami to use for the web instance"
  default     = "ami-00874d747dde814fa"
}

variable "web_server_public_key" {
  default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOi/5ltdmHwW9xBnfpYHghuvQum4hQrAEjFjbPlI9fdqGk2deCHi5yr7llKslAtbeeEqpx8DI9aBUoTnw9kapDue03jFpWG9yLItqXElkMD5Ft2BAfXgwqVtntpt1h3n4mTLHj1Z6GNnLdLbpTA+3HabyU12TZ5x3vinZ0H0kOq9Spt1hCW6F1PUf+KRR6BQ/q78tPZL75rcY4d/rkF4lqS2Q/SatYGxsZCV/P/ScmBCKRrJIMDCD/q5tMFi1p2sGEdpvUci7ZfiC13mVsWI52v5HxGXqkcuZm6NWJCA8g+yjzr7nCKHz0MrUDvxwidg8TtNrvtaM0r61h+HcLL6QP"
}

variable "web_server_path_to_private_key" {
  default       = "dales-dead-bug_frontend_web_server_dev_keypair.pem"
}

