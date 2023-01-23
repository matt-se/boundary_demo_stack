variable "worker_ami" {
  description = "ami to use for the worker instance"
  default     = "ami-0b5eea76982371e91"
}

variable "public_key" {
  default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCLi9c5+rSxHcPFBEwpRAlLNug4eDXCbeu8KSqsRZLvEW3MJZOtTwyMKpBp77QeK23YhX9CeKbOGvb7+GajXWHH85L7MVrZ7BSa9iSMDhlUJpgBjglNMe8UqXpxgajII5VyFbQog0dfo++GJ39uufPYzlrZ1w+M7g8psf9uELXAB97/srBPkjc45Lq+WNkeuIGyHHP4GgeWQyxUWc2619/2r/V91l5QnqQGAXDzP2qsvM/XV2iYEm3L/bngj2JkOAC0m1k/vm7g//FQzvQ3eAjA8Sz7XERZ+79+GWsbq8x/wmrMAGZvyCzgx17Op95R9BKH5xFj1F5axMPRl0LzgpoL"
}

variable "path_to_private_key" {
  default       = "key.pem"
}