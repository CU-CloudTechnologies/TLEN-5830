resource "aws_security_group" "db" {
    name = "dbserver"
    description = "Allow mysql and web group connections."

	ingress {
	from_port = "22"
	to_port = "22"
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
	ingress {

	from_port = "3306"
	to_port = "3306"
	protocol = "tcp"
	cidr_blocks =["${var.private-cidr}"]

}

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.public-cidr}"]
    }
    ingress {
        from_port = 0
        to_port =  0
        protocol = "-1"
        cidr_blocks = ["${var.private-cidr}"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"
    tags {
        Name = "Data Base"
    }
}

data "template_file" "db_setup"{
  template = "${file("dbserver.tpl")}"
}

resource "aws_instance" "db-1" {
    ami = "${var.ami}"
    availability_zone = "${var.avail_zone}"
    instance_type = "${var.inst_type}"
    key_name = "${var.ssh_key_name}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${aws_subnet.private.id}"
    private_ip = "${var.dbserver_private_ip}"
    associate_public_ip_address = true
    source_dest_check = false
    user_data = "${data.template_file.db_setup.rendered}"
    tags {
        Name = "MySQL Database server"
    }
}
