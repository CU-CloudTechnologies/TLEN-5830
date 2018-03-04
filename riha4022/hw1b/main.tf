##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-2"
}

##################################################################################
# RESOURCES
##################################################################################


  resource "aws_vpc" "default" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = "True"
  
  tags {
  Name = "RH_vpc"
  }
}

  resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

  resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

  resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone		  =  "us-west-2b"
  cidr_block              = "172.16.16.0/20"
  map_public_ip_on_launch = true
  
  tags {
  Name = "Public"
  }
}

  resource "aws_subnet" "private" {
  availability_zone		  = "us-west-2a"
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "172.16.32.0/20"
  
   tags {
  Name = "Private"
  }
}


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

  resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.private.id}","${aws_subnet.public.id}"]

  tags {
    Name = "My DB subnet group"
  }
}
  
  resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.37"
  instance_class       = "db.t2.micro"
  name                 = "terraform"
  username             = "foo"
  password             = "${var.db_instance_password}"
  parameter_group_name = "default.mysql5.6"
  skip_final_snapshot  = "True"
  availability_zone    = "us-west-2b"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  db_subnet_group_name	= "${aws_db_subnet_group.default.id}"
 
  tags {
  Name = "RH_aws_db_instance"
  }
 
}

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

  resource "aws_instance" "nginx" {
  count = "${var.count_aws_instance}"
  ami	        = "ami-1ee65166"
  instance_type = "t2.micro"
  key_name	= "${var.key_pair}"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  subnet_id 		= "${aws_subnet.public.id}"

  lifecycle {
    create_before_destroy = "True"
  }
  
  
  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"    
  }
  
  provisioner remote-exec {
	inline = ["touch /home/ubuntu/to_copy.html",
	"touch /home/ubuntu/default"
	]
  }

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
  
  provisioner "file" {
  source = "nginx_config.txt"
  destination = "/home/ubuntu/default"
  
  }
  
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

 
##################################################################################
# OUTPUT
##################################################################################

 output "aws_instance_public_dns" {
    value = ["${aws_instance.nginx.*.public_dns}"]
 }

 output "aws_DB_instance_public_dns" {
    value = "${aws_db_instance.default.address}"
 }
 
 output "aws_elb_public_dns" {
    value = "${aws_elb.default.dns_name}"
 }
 
