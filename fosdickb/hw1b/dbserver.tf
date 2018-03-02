resource "aws_security_group" "database" {
    name = "db-1"
    description = "Allow mysql and web group connections."

    ingress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["${var.public_cidr}"]
    }
    ingress {
        from_port = 0
        to_port =  0
        protocol = "-1"
        cidr_blocks = ["${var.private_cidr}"]
    }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"
    tags {
        Name = "DataBaseSecGroup"
    }
}

data "template_file" "db_setup"{
  template = "${file("dbsetup.tpl")}"
}

resource "aws_instance" "db-1" {
    ami = "${var.ami_id}"
    availability_zone = "${var.availability_zone}"
    instance_type = "${var.instance_type}"
    key_name = "${var.ssh_key_name}"
    vpc_security_group_ids = ["${aws_security_group.database.id}"]
    subnet_id = "${aws_subnet.private.id}"
    private_ip = "10.0.16.100"
    private_ip = "${var.db_server_private_ip}"
    # We'll need this to install things if we don't use a prebuilt image
    associate_public_ip_address = true
    source_dest_check = false
    user_data = "${data.template_file.db_setup.rendered}"

    tags {
        Name = "MySQL Server 1"
    }
}
