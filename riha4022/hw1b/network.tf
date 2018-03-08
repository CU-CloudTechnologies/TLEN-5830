#Configure a VPC for the 2-tier architecture 
  resource "aws_vpc" "default" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = "True"
  
  tags {
  Name = "RH_vpc"
  }
}

#Configure the internet gateway to be used by the configured VPC
  resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

#Configure the routing table to have the route-entry
  resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

#Configure the public subnet of the CIDR block
  resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone		  =  "us-west-2b"
  cidr_block              = "${var.aws_subnet_public}"
  map_public_ip_on_launch = true
  
  tags {
  Name = "Public"
  }
}

#Configure the private subnet of the CIDR block
  resource "aws_subnet" "private" {
  availability_zone		  = "us-west-2a"
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.aws_subnet_private}"
  
   tags {
  Name = "Private"
  }
}
