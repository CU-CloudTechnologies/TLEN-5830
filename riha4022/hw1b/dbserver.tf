#To create the subnet group to be used by the database instance
  resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.private.id}","${aws_subnet.public.id}"]

  tags {
    Name = "My DB subnet group"
  }
}

#Create the db instance and configure it to be a mysql server
  resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.37"
  instance_class       = "db.t2.micro"
  name                 = "terraform"
  username             = "foo"
  password             = "${var.db_instance_password}"
  parameter_group_name = "default.mysql5.6"
  skip_final_snapshot  = "True"
  availability_zone    = "us-west-2b"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  db_subnet_group_name	= "${aws_db_subnet_group.default.id}"
 
  tags {
  Name = "RH_aws_db_instance"
  }
 
}
