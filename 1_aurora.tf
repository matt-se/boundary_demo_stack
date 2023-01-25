resource "aws_db_subnet_group" "subnet" {
  name       = "${var.app_prefix}_db_subnet_${var.environment}"
  subnet_ids = [aws_subnet.subnet_public.id, aws_subnet.subnet_public2.id]
}


resource "aws_db_instance" "db" {
  allocated_storage    = 10
  db_name              = "mydb"
  identifier           = "${var.app_prefix}-db-subnet-${var.environment}"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnet.name
}