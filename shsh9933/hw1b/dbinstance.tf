resource "aws_instance" "database" {
        ami = "${var.ami_id}"
        instance_type = "${var.instance_type}"
        associate_public_ip_address = "false"
        subnet_id = "${aws_subnet.privatenetwork.id}"
        vpc_security_group_ids = ["${aws_security_group.database.id}"]
        tags {
                Name = "database"
        }
        key_name = "${var.ssh_key_name}"
        user_data = <<HEREDOC
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y mysql55-server
        sudo service mysqld start
        sudo /usr/bin/mysqladmin -u root password 'secret'
        mysql -u root -psecret -e "CREATE USER 'root'@'%' identified by 'secret';" mysql
		mysql -u root -psecret -e "grant all privileges on *.* to 'root'@'%';" mysql
		mysql -u root -psecret -e "CREATE DATABASE terraformdb;" mysql
        mysql -u root -psecret -e "CREATE TABLE table1 (col1 varchar(255));" terraformdb
        mysql -u root -psecret -e "INSERT INTO table1 (col1) values ('Hello Cloud Technologies') ;" terraformdb
HEREDOC
}