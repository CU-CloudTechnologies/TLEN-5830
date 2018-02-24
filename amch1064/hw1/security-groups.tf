resource "aws_security_group" "web-dmz" {
  
  vpc_id = "${aws_vpc.cloud-tech.id}"

  name        = "web-dmz"
  description = "Web Server DMZ"
}

resource "aws_security_group_rule" "allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id   = "${aws_security_group.web-dmz.id}"
}

resource "aws_security_group_rule" "allow_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id   = "${aws_security_group.web-dmz.id}"
}

resource "aws_security_group_rule" "allow_icmp" {
  type            = "ingress"
  from_port       = 8
  to_port         = 0
  protocol        = "icmp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id   = "${aws_security_group.web-dmz.id}"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id   = "${aws_security_group.web-dmz.id}"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "db-dmz" {
  name        = "db-dmz"
  description = "Allow All traffic on the DB network"

  vpc_id = "${aws_vpc.cloud-tech.id}"

}

resource "aws_security_group_rule" "allow_all_tcp" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id   = "${aws_security_group.db-dmz.id}"
}

resource "aws_security_group_rule" "allow_all_db_egress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id   = "${aws_security_group.db-dmz.id}"
  cidr_blocks = ["0.0.0.0/0"]
}