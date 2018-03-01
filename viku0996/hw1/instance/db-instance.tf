resource "aws_db_instance" "database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.37"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "master"
  password             = "mastersql"
  identifier           = "database"
  parameter_group_name = "default.mysql5.6"
  skip_final_snapshot  = "true"
  vpc_security_group_ids = ["${var.security-group-database}"]
  db_subnet_group_name = "${var.db-private-subnet}"
  tags {
    name = "mydb"
  }
}

output "dbname" {
  value = "${aws_db_instance.database.address}"
}