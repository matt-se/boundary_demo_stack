resource "aws_db_instance" "db" {
  allocated_storage    = 10
  db_name              = "mydb"
  identifier = "${var.app_prefix}_db_${var.environment}"
  engine               = "postgres"
  #engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_subnet.subnet_public.id
}