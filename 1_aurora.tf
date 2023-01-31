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