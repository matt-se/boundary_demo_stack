resource "aws_db_subnet_group" "subnet" {
  name       = "${var.app_prefix}_db_sn_${var.environment}"
  subnet_ids = [aws_subnet.subnet_public.id, aws_subnet.subnet_public2.id]
}


resource "aws_db_instance" "db" {
  allocated_storage    = 10
  db_name              = "mydb"
  identifier           = "${var.app_prefix}-db-${var.environment}"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  username             = var.aws_rds_username
  password             = var.aws_rds_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnet.name
  vpc_security_group_ids = [aws_security_group.sg_db.id]
}




### Boundary Config for RDS host
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
  name         = "${var.app_prefix}_rds_${var.environment}_rds_remote_access"
  type         = "tcp"
  default_port = "5432"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set_static.rds.id
  ]
  ingress_worker_filter = "\"worker\" in \"/tags/type\""
}


### RDS Security Group
resource "aws_security_group" "sg_db" {
  name   = "${var.app_prefix}_db_sg_${var.environment}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_worker.id]
}
}

####### outputs
output "db_instance_id" {
  value = aws_db_instance.db.id
}
  
output "db_instance_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_instance_arn" {
  value = aws_db_instance.db.arn
}

output "db_instance_address" {
  value = aws_db_instance.db.address
}

output "rds_address" {
  value = aws_db_instance.db.address
}

output "rds_id" {
  value = aws_db_instance.db.id
}