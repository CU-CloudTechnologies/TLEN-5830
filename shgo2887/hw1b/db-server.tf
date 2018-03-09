data "template_file" "db_setup"{
  	template = "${file("dbsetup.tpl")}"
}


resource "aws_instance" "db-1" {
    	ami = "${var.ami_id1}"
    	availability_zone = "${var.availability_zone}"
    	instance_type = "${var.instance_type}"
    	key_name = "${var.ssh_key_name}"
    	vpc_security_group_ids = ["${aws_security_group.database.id}"]
    	subnet_id = "${aws_subnet.private.id}"
    	private_ip = "10.1.3.100"
    	private_ip = "${var.db_server_private_ip}"
    # We'll need this to install things if we don't use a prebuilt image
    	associate_public_ip_address = true
    	source_dest_check = false
    	user_data = "${data.template_file.db_setup.rendered}"

    	tags {
        	Name = "MySQL Server 1"
    	}
}
