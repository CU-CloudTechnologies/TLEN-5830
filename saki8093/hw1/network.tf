provider "aws" {
 shared_credentials_file="${var.ssh_keyfile}"
}
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc-cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "Virtual Private Cloud"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id          = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.public-cidr}"
  map_public_ip_on_launch = true
  availability_zone = "${var.avail_zone}"
}

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.private-cidr}"
  map_public_ip_on_launch = false 
  availability_zone = "${var.avail_zone}"
}
