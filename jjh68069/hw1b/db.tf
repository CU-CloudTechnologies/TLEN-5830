resource "aws_db_instance" "db_server" {
	engine = "mysql"
	allocated_storage = 20
	instance_class = "db.t2.micro"
	name = "application_db"
	username = "jason"
	password = "H3ll0world!"
}