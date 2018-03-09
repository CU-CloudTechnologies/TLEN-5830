resource "aws_security_group" "database" {
  name = "database"
  tags {
        Name = "database"
  }
  vpc_id = "${aws_vpc.my_vpc.id}"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "TCP"
      security_groups = ["${aws_security_group.webserver.id}"]
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


data "template_file" "sqlserver_setup"{
  template = "${file("sqlserver.tpl")}"
}

# Create a sql server
resource "aws_instance" "sql" {
  ami = "${var.ami_sql}" 
  associate_public_ip_address = false
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.private_subnet.id}"
  private_ip = "172.28.3.50"
  key_name = "${var.ssh_key_name}"
  vpc_security_group_ids = ["${aws_security_group.database.id}"]
  user_data =  "${data.template_file.sqlserver_setup.rendered}"
  tags {
	Name = "Sqlserver"
    }
}

