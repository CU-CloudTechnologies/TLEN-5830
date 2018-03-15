resource "aws_instance" "webserver" {
	ami = "${var.ami_id}"
	instance_type = "${var.instance_type}"
	associate_public_ip_address = "true"
	subnet_id = "${aws_subnet.publicnetwork.id}"
	vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
	tags {
		Name = "webserver"
	}
	key_name = "${var.ssh_key_name}"
	user_data = <<HEREDOC
	#!/bin/bash
	sudo yum update -y
	sudo yum install -y httpd24
	sudo yum install -y php56
	sudo yum install -y php56-mysqlnd
	sudo service httpd start
	sudo chkconfig httpd on
	sudo echo "<?php" >> /var/www/html/cloudtech.php
	sudo echo "\$conn = new mysqli('mydatabase.terraform.internal' , 'root' , 'secret' , 'terraformdb');" >> /var/www/html/cloudtech.php
	sudo echo "if (\$conn->connect_error) { die('Connection Failed: ' . \$conn->connect_error);}" >> /var/www/html/cloudtech.php
	sudo echo "\$sql = 'SELECT * FROM table1'; " >> /var/www/html/cloudtech.php
	sudo echo "\$result = \$conn->query(\$sql); " >> /var/www/html/cloudtech.php
	sudo echo "while(\$row = \$result->fetch_assoc()) { echo \$row['col1'] ;} " >> /var/www/html/cloudtech.php
	sudo echo "\$conn->close(); " >> /var/www/html/cloudtech.php
	sudo echo "?>" >> /var/www/html/cloudtech.php
HEREDOC
}