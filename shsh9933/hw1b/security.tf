resource "aws_security_group" "webserver" {
	name = "webserver"
	tags {
		Name = "webserver"
	}
	vpc_id = "${aws_vpc.terraform1.id}"

	ingress {
		to_port = 0
		from_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "database" {
	name = "database"
	tags {
		Name = "database"
	}
	vpc_id = "${aws_vpc.terraform1.id}"

	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}