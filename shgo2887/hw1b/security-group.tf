resource "aws_security_group" "database"{
        name = "vpc_hw_db"
        ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["${var.public_cidr}"]
        }

        ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["${var.private_cidr}"]
        }
        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
        vpc_id = "${aws_vpc.vpc-hw.id}"
        tags{
                Name = "DB SecGrp"
        }
}

resource "aws_security_group" "web"{
        name = "vpc_hw_http"
        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                from_port = 443
                to_port = 443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                from_port = -1
                to_port = -1
                protocol = "icmp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
        vpc_id = "${aws_vpc.vpc-hw.id}"
        tags{
                Name = "HTTP SecGrp"
        }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
