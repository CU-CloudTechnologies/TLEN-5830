resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow HTTP, HTTPS and ICMP connections."

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

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"
    tags {
        Name = "WebServerSecGroup"
    }
}

data "template_file" "web_setup"{
  template = "${file("websetup.tpl")}"
}

resource "aws_instance" "web-1" {
    ami = "${var.ami_id}"
    availability_zone = "${var.availability_zone}"
    instance_type = "${var.instance_type}"
    key_name = "${var.ssh_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    user_data = "${data.template_file.web_setup.rendered}"
    tags {
        Name = "Web Server 1"
    }
}

resource "aws_eip" "web-1" {
    instance = "${aws_instance.web-1.id}"
    vpc = true
}
