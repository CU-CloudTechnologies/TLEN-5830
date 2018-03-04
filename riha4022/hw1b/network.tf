  resource "aws_vpc" "default" {
  cidr_block = "{var.cidr_block}"
  enable_dns_hostnames = "True"
  
  tags {
  Name = "RH_vpc"
  }
}

  resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

  resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

  resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone		  =  "us-west-2b"
  cidr_block              = "{var.aws_subnet_public}"
  map_public_ip_on_launch = true
  
  tags {
  Name = "Public"
  }
}

  resource "aws_subnet" "private" {
  availability_zone		  = "us-west-2a"
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "{var.aws_subnet_private}"
  
   tags {
  Name = "Private"
  }
}
