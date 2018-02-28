resource "aws_security_group" "Database" {
  name = "Database"
  tags {
        Name = "Database"
  }
  description = "inbound tcp conn"
  vpc_id = "${aws_vpc.terraformvpc.id}"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "TCP"
      security_groups = ["${aws_security_group.WebPage.id}"]
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

data "template_file" "db_am"{
  template = "${file("db_am.tpl")}"
}

resource "aws_instance" "mysqldatabase_am" {
  ami = "${var.ami}" 
  instance_type = "${var.instance_type}"
  associate_public_ip_address = "false"
  subnet_id = "${aws_subnet.Priv.id}"
  private_ip = "${var.db_server_private_ip}"
  vpc_security_group_ids = ["${aws_security_group.Database.id}"]
  key_name = "${var.ssh_key_name}"
  user_data = "${data.template_file.db_am.rendered}"
  tags {
        Name = "terraform-dbserver_am"
  } 
}
