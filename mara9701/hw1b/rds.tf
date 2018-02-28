/*
Define a mysql database using rds
*/

  
resource "aws_db_instance" "default" {
  allocated_storage   	 = 10
  storage_type        	 = "gp2"
  engine              	 = "mysql"
  engine_version         = "5.7.19"
  instance_class         = "db.t2.micro"
  name                 	 = "mydb"
  username             	 = "admin"
  password             	 = "secret"
  db_subnet_group_name   = "${aws_db_subnet_group.default.id}"
  vpc_security_group_ids = ["${aws_security_group.Database.id}"]
  port					 = "3306"
  identifier             = "terraform-db"
 
  #Comment the below line if snapshot not present. By using existing snapshot, all the database dumps will be ingerited by the new snapshot
  #snapshot_identifier    = "terraform-20180205175403775800000001-final-snapshot"
  skip_final_snapshot    = "true"
}

resource "aws_db_subnet_group" "default" {
  name        = "subnet_group"
  description = "The main group of subnets"
  subnet_ids  = ["${aws_subnet.private_subnet1.id}", "${aws_subnet.private_subnet2.id}"]
}

#Print the hostname of the database
output "db_name" {
    value = "${aws_db_instance.default.endpoint}"
    description = "Name of database"
}


