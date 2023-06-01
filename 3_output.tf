output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  value = aws_subnet.subnet_public.id
}

output "subnet_arn" {
  value = aws_subnet.subnet_public.arn
}

output "sg_web_server_arn" {
  value = aws_security_group.sg_web_server.arn
}

output "sg_web_server_id" {
  value = aws_security_group.sg_web_server.id
}


output "sg_worker_arn" {
  value = aws_security_group.sg_worker.arn
}

output "sg_worker_id" {
  value = aws_security_group.sg_worker.id
}


output "worker_instance_id" {
  value = aws_instance.boundary_worker.id
}


output "boundary_worker_reg_code" {
  value = boundary_worker.worker.controller_generated_activation_token
}

output "boundary_worker_downstream_reg_code" {
  value = boundary_worker.downstream_worker.controller_generated_activation_token
}