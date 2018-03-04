resource "aws_security_group" "WebPage" {
  name = "WebPage"
  tags {
        Name = "WebPage"
  }
  description = "inbound web service 80"
  vpc_id = "${aws_vpc.terraformvpc.id}"

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

data "template_file" "web_am"{
  template = "${file("web_am.tpl")}"
}

resource "aws_instance" "httpwebserver_am" {
  count = 2
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.NatOut.id}"
  vpc_security_group_ids = ["${aws_security_group.WebPage.id}"]
  key_name = "${var.ssh_key_name}"
   
  user_data = "${data.template_file.web_am.rendered}"
  tags {
        Name = "terraform-webserver_am"
  }
}