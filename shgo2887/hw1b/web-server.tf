data "template_file" "web_setup"{
  	template = "${file("websetup.tpl")}"
}

resource "aws_instance" "web-1" {
    	ami = "${var.ami_id1}"
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
