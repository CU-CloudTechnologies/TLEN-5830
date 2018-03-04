#Configure the security groups for allowing HTTP and SSH access to the webservers 
  resource "aws_security_group" "instance" {
  name = "terraform-security-group"
  vpc_id = "${aws_vpc.default.id}"
  
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
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
  
  tags {
  Name = "Terraform_Security_Group"
  }
  
  lifecycle {
    create_before_destroy = "True"
  }
}


#Cofiguring the Load balancer to listen to requests on port 80 and load balance between the different requests
  resource "aws_elb" "default" {
  name               = "foobar-terraform-elb"
  #availability_zones = ["us-west-2a"]
  security_groups	 = ["${aws_security_group.instance.id}"]
  subnets			 = ["${aws_subnet.public.id}","${aws_subnet.private.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.nginx.*.id}"]
  cross_zone_load_balancing   = true

  tags {
    Name = "RH_LB"
  }
}

#Configure the Nginx Webserver to run on an EC2 instance. The count variable will be used to spin up the required number of webservers for scaling
  resource "aws_instance" "nginx" {
  count = "${var.count_aws_instance}"
  ami	        = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name	= "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  subnet_id 		= "${aws_subnet.public.id}"

  lifecycle {
    create_before_destroy = "True"
  }
  
#This piece will be used to establish the connection with the spinned up instances for remote-exec operation  
  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"    
  }
  
#Used to create temporry files on the webservers which will be later used to change the configuration files of the nginx webserver as well as the index.html
  provisioner remote-exec {
	inline = ["touch /home/ubuntu/to_copy.html",
	"touch /home/ubuntu/default"
	]
  }

#This is the PHP script which will be used by the nginx server to query the database for getting the results. This file is copied to the temporary file to_copy.html
  provisioner "file" {
	content = <<-EOF
	<?php
	$servername = "${aws_db_instance.default.address}";
	$username = "${aws_db_instance.default.username}";
	$password = "${aws_db_instance.default.password}";
	$dbname = "${aws_db_instance.default.name}";

	// Create connection
	$conn = new mysqli($servername, $username, $password, $dbname);
	// Check connection
	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	} 
	echo "Using Terraform on Server";
	$sql = "SELECT S_ID, Subject, MARKS FROM T1";
	$result = $conn->query($sql);

	if ($result->num_rows > 0) {
		echo "<table><tr><th>S_ID</th><th>Subject</th><th>Marks</th></tr>";
		// output data of each row
		while($row = $result->fetch_assoc()) {
			echo "<tr><td>".$row["S_ID"]."</td><td>".$row["Subject"]."</td><td>".$row["MARKS"]."</td></tr>";
		}
		echo "</table>";
	} else {
		echo "0 results";
	}
	$conn->close();
	?>
	EOF
	
	destination = "/home/ubuntu/to_copy.html"
  }

#Copy the local file nginx_config to the remote location.  
  provisioner "file" {
  source = "nginx_config.txt"
  destination = "/home/ubuntu/default"
  
  }

#Script which wil be run on the remote location and will update the instance to run nginx server as well as insert values in the MySQL database.
  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install nginx mysql-client php-mysql php7.0-fpm php7.0 -y
  sudo service nginx start
  cm="create table if not exists T1 (S_ID INT(255) AUTO_INCREMENT NOT NULL, Subject VARCHAR(255) NOT NULL, MARKS INT(255) NOT NULL, PRIMARY KEY (S_ID), UNIQUE(Subject)); \
  Insert into T1 (Subject,Marks) values ('Maths',100);"
  mysql -h ${aws_db_instance.default.address} -u ${aws_db_instance.default.username} -p${aws_db_instance.default.password} -e "$cm" terraform
  mv /home/ubuntu/to_copy.html /var/www/html/myhomepage.php
  sudo mv /home/ubuntu/default /etc/nginx/sites-available/default
  sudo service nginx restart
  sudo service php7.0-fpm restart
  EOF

  tags {
  Name = "Rishabh_Hastu_aws_instance"
  }
 
}

