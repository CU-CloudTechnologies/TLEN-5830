provider "aws" {
  region     = "us-east-1"
}

resource "aws_db_instance" "db_server" {
	engine = "mysql"
	allocated_storage = 20
	instance_class = "db.t2.micro"
	name = "application_db"
	username = "jason"
	password = "H3ll0world!"
	vpc_id = "${aws_vpc.default.id}"
    subnet_id = "${aws_subnet.public.id}"
    vpc_security_group_ids = ["${aws_security_group.database.id}"]
    subnet_id = "${aws_subnet.private.id}"
    private_ip = "${var.db_server_private_ip}"
}

output "address" { 
	value = "${aws_db_instance.db_server.address}"
 }

output "port" { 
	value = "${aws_db_instance.db_server.port}" 
}