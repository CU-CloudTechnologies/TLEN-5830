resource "aws_security_group" "webserver" {
  name = "webserver"
  tags {
        Name = "webserver"
  }
  vpc_id = "${aws_vpc.my_vpc.id}"
  ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
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

data "template_file" "webserver_setup"{
  template = "${file("webserver.tpl")}"
}

# Create a web server
resource "aws_instance" "web" {
  ami = "${var.ami_web}"
  associate_public_ip_address = true
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.public_subnet.id}"
  key_name = "${var.ssh_key_name}"
  vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
  count = 2
  user_data = "${data.template_file.webserver_setup.rendered}"
  tags{
	Name = "Webserver"
  }
}
