/*
Script to setup a new vpc
*/

provider "aws" {
  #access_key = "${var.aws_access_key}"
  #secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc-cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "main_vpc"
  }
}

/*
3 different subnets are created. 1 public and 2 private subnets (for RDS)
*/

#Public Subnet 1
resource "aws_subnet" "public_subnet"{
	vpc_id= "${aws_vpc.main.id}"
	cidr_block = "${var.Subnet-Public_cidr}"
	tags {
		Name= "public_subnet"
	}
}

#Private Subnet 1
resource "aws_subnet" "private_subnet1" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.Subnet-Private_cidr1}"
  availability_zone = "${var.az_1}"
  tags {
        Name = "private_subnet"
  }
}

#Private Subnet 2
resource "aws_subnet" "private_subnet2" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.Subnet-Private_cidr2}"
  availability_zone = "${var.az_2}"
  tags {
        Name = "private_subnet"
  }
}


/*
Update routing table and Default gateways
Add ACL if necessary or control using security groups
*/


#define a default gateway 
resource "aws_internet_gateway" "df_gw" {
	vpc_id = "${aws_vpc.main.id}"
	tags {
		Name = "Deafult gateway for internet"
	}
}

#Define the route table, add the default gateway
resource "aws_route" "internet_access" {
  route_table_id          = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.df_gw.id}"
}


#Assign an elastic IP
resource "aws_eip" "Nat" {
    vpc      = true
}




