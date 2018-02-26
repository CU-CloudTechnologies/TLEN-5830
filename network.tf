provider "aws" {}

resource "aws_vpc" "terraform1" {
	cidr_block = "${var.vpc_cidr}"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags { 
		Name = "Terraform_VPC"
	}
}

resource "aws_internet_gateway" "gateway1" {
	vpc_id = "${aws_vpc.terraform1.id}"
	tags {
		Name = "Terraform Internet Gateway"
	}
}

resource "aws_network_acl" "anyany" {
	vpc_id = "${aws_vpc.terraform1.id}"
	egress {
		protocol = "-1"
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 0
		to_port = 0
		rule_no = 2
	}
	ingress {
		protocol = "-1"
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 0
		to_port = 0
		rule_no = 1
	}
	tags {
		Name = "Allow All ACL"
	}
}

resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.terraform1.id}"
	tags {
		Name = "Public"
	}
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.gateway1.id}"
	}
}

resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.terraform1.id}"
	tags {
		Name = "Private"
	}
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = "${aws_nat_gateway.publicnetwork.id}"
	}
}

resource "aws_eip" "natip" {
	vpc = true
}

resource "aws_nat_gateway" "publicnetwork" {
	allocation_id = "${aws_eip.natip.id}"
	subnet_id = "${aws_subnet.publicnetwork.id}"
	depends_on = ["aws_internet_gateway.gateway1"]
}

resource "aws_subnet" "publicnetwork" {
	vpc_id = "${aws_vpc.terraform1.id}"
	cidr_block = "${var.public_cidr}"
	tags {
		Name = "publicnetwork"
	}
}

resource "aws_route_table_association" "publicnetwork" {
	subnet_id = "${aws_subnet.publicnetwork.id}"
	route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "privatenetwork" {
	vpc_id = "${aws_vpc.terraform1.id}"
	cidr_block = "${var.private_cidr}"
	tags {
		Name = "privatenetwork"
	}
}

resource "aws_route_table_association" "privatenetwork" {
	subnet_id = "${aws_subnet.privatenetwork.id}"
	route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route53_zone" "main" {
	name = "terraform.internal"
	vpc_id = "${aws_vpc.terraform1.id}"
	comment = "My terraform DNS"
}

resource "aws_route53_record" "database" {
	zone_id = "${aws_route53_zone.main.id}"
	name = "mydatabase.terraform.internal"
	type = "A"
	ttl = "300"
	records = ["${aws_instance.database.private_ip}"]
}






