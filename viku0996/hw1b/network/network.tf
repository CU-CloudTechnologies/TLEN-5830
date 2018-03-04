data "aws_availability_zones" "available" {}

#Configure a vpc for the setup
resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc-cidr}"
    enable_dns_hostnames = true
    tags {
      name = "vpc"
    }
}

resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "internet gateway"
    }
}

resource "aws_network_acl" "all" {
   vpc_id = "${aws_vpc.vpc.id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "network acl"
    }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
      Name = "public route table"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.public-subnet-cidr}"
  tags {
        Name = "public-subnet"
  }
 availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public-subnet.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.private-subnet-cidr}"
  tags {
        Name = "private-subnet"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name = "db subnet group"
  subnet_ids = ["${aws_subnet.private-subnet.id}", "${aws_subnet.public-subnet.id}"]
  tags {
    name = "DB Subnet Group"
  }
}

output "vpc" {
  value = "${aws_vpc.vpc.id}"
}

output "public-subnet" {
  value = "${aws_subnet.public-subnet.id}"
}

output "private-subnet" {
  value = "${aws_subnet.private-subnet.id}"
}

output "db-private-subnet" {
  value = "${aws_db_subnet_group.db-subnet-group.id}"
}
