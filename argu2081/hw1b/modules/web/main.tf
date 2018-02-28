/* Security group for the web */
resource "aws_security_group" "web_server_sg" {
  name        = "${var.environment}-web-server-sg"
  description = "Security group for web that allows web traffic from internet"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-web-server-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "web_inbound_sg" {
  name        = "${var.environment}-web-inbound-sg"
  description = "Allow HTTP from Anywhere"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-web-inbound-sg"
  }
}
/* Security Group for Database Server */
resource "aws_security_group" "Database" {
  name = "Database"
  tags {
        Name = "Database"
  }
  description = "ONLY tcp CONNECTION INBOUND"
  vpc_id = "${var.vpc_id}"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "TCP"
      security_groups = ["${aws_security_group.web_server_sg.id}"]
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

/* Web servers */
resource "aws_instance" "web" {
  count             = "${var.web_instance_count}"
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${var.private_subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.web_server_sg.id}"
  ]
  key_name          = "${var.key_name}"
  tags = {
    Name        = "${var.environment}-web-${count.index+1}"
    Environment = "${var.environment}"
  }
  user_data = <<HEREDOC
#!/bin/bash
sudo su
apt install mysql-client
apt install -y apache2 apache2-doc apache2-utils
apt install -y php php-mysqlnd php7.0-mysql
apt-get install php libapache2-mod-php
a2enmod mpm_prefork && sudo a2enmod php7.0
service apache2 restart
ip=\'"${aws_instance.database.private_ip}"\'
echo "<?php" > /var/www/html/cloudtech.php
echo "\$servername = $ip;" >> /var/www/html/cloudtech.php
echo "\$username = 'admin';" >> /var/www/html/cloudtech.php
echo "\$password = 'secret';" >> /var/www/html/cloudtech.php
echo "\$dbname = 'simpledb';" >> /var/www/html/cloudtech.php
echo "\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);" >> /var/www/html/cloudtech.php
echo "\$query = mysqli_query(\$conn,'SELECT * FROM lab1')" >> /var/www/html/cloudtech.php
echo "    or die (mysqli_fetch_error(\$query));" >> /var/www/html/cloudtech.php
echo "while (\$row = mysqli_fetch_array(\$query)) {" >> /var/www/html/cloudtech.php
echo "    echo \$row['testdata'];" >> /var/www/html/cloudtech.php
echo "}" >> /var/www/html/cloudtech.php
echo "?>" >> /var/www/html/cloudtech.php
/etc/init.d/apache2 restart
HEREDOC
}


/* Database Servers */
resource "aws_instance" "database" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "false"
  subnet_id = "${var.private_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.Database.id}","${aws_security_group.web_server_sg.id}","${aws_security_group.web_inbound_sg.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "database"
  }
  user_data = <<HEREDOC
#!/bin/bash
sudo su
sudo apt-get update
apt -y install mariadb-server
debconf-set-selections <<< 'mysql-server mysql-server/root_password password dbsecret'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password dbsecret'
sed -i -e 's/bind-address/#bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf
service mysql restart
mysql -u root -pdbsecret -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by 'dbsecret' WITH GRANT OPTION;"
mysql -u root -pdbsecret -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql -u root -pdbsecret -e "CREATE DATABASE simpledb;"
mysql -u root -pdbsecret -D simpledb -e "CREATE USER 'root'@'%' IDENTIFIED BY 'dbsecret';"
mysql -u root -pdbsecret -D simpledb -e 'CREATE TABLE lab1 (testdata varchar(255));'
mysql -u root -pdbsecret -D simpledb -e "INSERT INTO lab1 (testdata) values ('Hello Cloud Technologies');"
service mysql restart
HEREDOC
}



/*DNS and DHCP*/
resource "aws_vpc_dhcp_options" "mydhcp" {
    domain_name = "${var.DnsZoneName}"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
      Name = "My internal name"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${var.vpc_id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.mydhcp.id}"
}

/* DNS PART ZONE AND RECORDS */
resource "aws_route53_zone" "main" {
  name = "${var.DnsZoneName}"
  vpc_id = "${var.vpc_id}"
  comment = "Managed by terraform"
}

resource "aws_route53_record" "database" {
   zone_id = "${aws_route53_zone.main.zone_id}"
   name = "mydatabase.${var.DnsZoneName}"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.database.private_ip}"]
}

/* Load Balancer */
resource "aws_elb" "web" {
  name            = "${var.environment}-web-lb"
  subnets         = ["${var.public_subnet_id}"]
  security_groups = ["${aws_security_group.web_inbound_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    interval            = 6
    target              = "TCP:80"
    timeout             = 5
}
  instances = ["${aws_instance.web.*.id}"]

  tags {
    Environment = "${var.environment}"
  }
}
