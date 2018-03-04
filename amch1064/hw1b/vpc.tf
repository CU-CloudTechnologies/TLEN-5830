# Create a VPC to launch our instances into
resource "aws_vpc" "cloud-tech" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
        Name = "cloud-tech-vpc"
  }
}

resource "aws_subnet" "lab1-public" {
  vpc_id = "${aws_vpc.cloud-tech.id}"
  cidr_block = "${var.public_subnet}"
  availability_zone = "${var.availability_zone}"

  tags {
        Name = "10.0.1.0 - us-east-1a"
    }
}

resource "aws_subnet" "lab1-private" {
  vpc_id = "${aws_vpc.cloud-tech.id}"
  cidr_block = "${var.private_subnet}"
  availability_zone = "${var.availability_zone_b}"

  tags {
        Name = "10.0.2.0 - us-east-1b"
    }
}


resource "aws_internet_gateway" "cloud-tech" {
    vpc_id = "${aws_vpc.cloud-tech.id}"
}

resource "aws_route_table" "cloud-tech-internet" {
    vpc_id = "${aws_vpc.cloud-tech.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cloud-tech.id}"
    }

    tags {
        Name = "cloud-tech-internet"
    }
}

resource "aws_route_table_association" "us-east-1a-public" {
    subnet_id = "${aws_subnet.lab1-public.id}"
    route_table_id = "${aws_route_table.cloud-tech-internet.id}"
}

resource "aws_db_subnet_group" "lab1" {
  name       = "main"
  subnet_ids = ["${aws_subnet.lab1-private.id}","${aws_subnet.lab1-public.id}"]

  tags {
    Name = "My DB subnet group"
  }
}
