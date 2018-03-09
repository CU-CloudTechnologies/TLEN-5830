resource "aws_vpc" "vpc-hw" {
  	cidr_block = "${var.vpc_cidr}"
  	enable_dns_support = true
  	enable_dns_hostnames = true
  	tags {
    		Name = "Chetan VPC"
  	}
}

resource "aws_internet_gateway" "gateway" {
  	vpc_id = "${aws_vpc.vpc-hw.id}"
	tags{
		Name="Gateway"
	}
}

resource "aws_route" "internet_access" {
  	route_table_id          = "${aws_vpc.vpc-hw.main_route_table_id}"
  	destination_cidr_block  = "0.0.0.0/0"
  	gateway_id              = "${aws_internet_gateway.gateway.id}"
}

resource "aws_subnet" "public" {
  	vpc_id                  = "${aws_vpc.vpc-hw.id}"
  	cidr_block              = "${var.public_cidr}"
  	map_public_ip_on_launch = true
  	availability_zone = "${var.availability_zone}"
}

resource "aws_subnet" "private" {
  	vpc_id                  = "${aws_vpc.vpc-hw.id}"
  	cidr_block              = "${var.private_cidr}"
  	map_public_ip_on_launch = false 
  	availability_zone = "${var.availability_zone}"
}
