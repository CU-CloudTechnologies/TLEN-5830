resource "aws_vpc" "my_vpc" {
    cidr_block = "${var.cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.my_vpc.id}"
}

resource "aws_network_acl" "all" {
   vpc_id = "${aws_vpc.my_vpc.id}"
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
        Name = "open acl"
    }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "${var.Private_subnet}"
  tags {
        Name = "public_subnet"
  }
  availability_zone = "us-west-2b"
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "${var.Public_subnet}"
  tags {
        Name = "public_subnet"
  }
 availability_zone = "us-west-2b"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  tags {
      Name = "Public"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  tags {
      Name = "Private"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.public_subnet.id}"
  }
}

resource "aws_eip" "forNat" {
    vpc      = true
}
resource "aws_nat_gateway" "public_subnet" {
    allocation_id = "${aws_eip.forNat.id}"
    subnet_id = "${aws_subnet.public_subnet.id}"
    depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table_association" "private_subnet" {
    subnet_id = "${aws_subnet.private_subnet.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public_subnet" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.public.id}"
}

