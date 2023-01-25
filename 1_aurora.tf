resource "aws_db_subnet_group" "subnet" {
  name       = "${var.app_prefix}_db_subnet_${var.environment}"
  subnet_ids = [aws_vpc.vpc.subnet_public.id]
}


resource "aws_db_instance" "db" {
  allocated_storage    = 10
  db_name              = "mydb"
  identifier           = "${app_prefix}-db-subnet-${var.environment}"
  engine               = "postgres"
  #engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnet.name
}