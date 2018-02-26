
resource "aws_vpc" "terraformvpc" {
  cidr_block = "${var.vpc_ips}"
  enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      Name = "VPC created using Terraform"
    }
}
resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.terraformvpc.id}"
    tags {
        Name = "internet gw"
    }
}
resource "aws_network_acl" "net_acl" {
   vpc_id = "${aws_vpc.terraformvpc.id}"
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
        Name = "ACL"
    }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.terraformvpc.id}"
  tags {
      Name = "Public route table"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.terraformvpc.id}"
  tags {
      Name = "Private route table"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.NatOut.id}"
  }
}
resource "aws_eip" "NAT" {
    vpc = true
}
resource "aws_nat_gateway" "NatOut" {
    allocation_id = "${aws_eip.NAT.id}"
    subnet_id = "${aws_subnet.NatOut.id}"
    depends_on = ["aws_internet_gateway.gw"]
}
resource "aws_subnet" "NatOut" {
  vpc_id = "${aws_vpc.terraformvpc.id}"
  cidr_block = "${var.public_cidr}"
  tags {
        Name = "NatOut"
  }
 availability_zone = "${var.availability_zone}"
}
resource "aws_route_table_association" "NatOut" {
    subnet_id = "${aws_subnet.NatOut.id}"
    route_table_id = "${aws_route_table.public_route_table.id}"
}
resource "aws_subnet" "Priv" {
  vpc_id = "${aws_vpc.terraformvpc.id}"
  cidr_block = "${var.private_cidr}"
  tags {
        Name = "PrivateSub"
  }
  availability_zone = "${var.availability_zone}"
}
resource "aws_route_table_association" "Priv" {
    subnet_id = "${aws_subnet.Priv.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}
