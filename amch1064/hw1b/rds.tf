
resource "aws_db_instance" "dbsrv-01" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.6.37"
  instance_class       = "db.t2.micro"
  name                 = "lab1db"
  username             = "cloudtech"
  password             = "Super123"
  db_subnet_group_name = "${aws_db_subnet_group.lab1.id}"
  parameter_group_name = "default.mysql5.6"
  vpc_security_group_ids = ["${aws_security_group.db-dmz.id}"]
  skip_final_snapshot = "true"
}
