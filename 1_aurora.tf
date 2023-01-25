resource "aws_db_instance" "db" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "postgres"
  #engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}