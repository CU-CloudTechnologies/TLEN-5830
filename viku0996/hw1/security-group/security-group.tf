/*resource "aws_security_group" "elb" {
  name        = "elb"
  description = "security group for terraform"
  vpc_id      = "${aws_vpc.default.id}"
  tags {
    name = "elb"
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}*/

resource "aws_security_group" "webserver" {
  name = "webserver"
  tags {
        Name = "webserver"
  }
  description = "HTTP, SSH, MYSQL connection inbound"
  vpc_id = "${var.vpc}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database" {
  name = "database"
  tags {
        Name = "database"
  }
  description = "SSH, MYSQL connection inbound"
  vpc_id = "${var.vpc}"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
#    security_groups = ["${aws_security_group.webserver.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "security-group-webserver" {
  value = "${aws_security_group.webserver.id}"
}

output "security-group-database" {
  value = "${aws_security_group.database.id}"
}