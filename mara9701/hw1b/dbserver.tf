#Deploy the database Server

data "template_file" "db_setup"{
  template = "${file("dbsetup.tpl")}"
}

resource "aws_instance" "db" {
    ami = "${var.ami}"
    availability_zone = "${var.az_1}"
	instance_type = "t2.micro"
    key_name = "${aws_key_pair.default.id}"
    vpc_security_group_ids = ["${aws_security_group.Database.id}"]
    subnet_id = "${aws_subnet.private_subnet1.id}"
    private_ip = "${var.db_server_private_ip}"
    source_dest_check = false
	associate_public_ip_address = true
    user_data = "${data.template_file.db_setup.rendered}"
	
	connection {
		key_file = "${var.key_path}"
	}

    tags {
        Name = "MySQL Server"
    }
}


