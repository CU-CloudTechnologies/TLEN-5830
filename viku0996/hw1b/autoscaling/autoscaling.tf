#Configure launch configurations for new EC2 instances deployed
resource "aws_launch_configuration" "webserver-launch-conf" {
  name = "launch-config"
  image_id      = "${var.ami}"
  key_name      = "${var.key-name}"
  instance_type = "${var.instance-type}"
  associate_public_ip_address = "true"
  security_groups = ["${var.security-group-webserver}"]
#  spot_price    = "0.001"
  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.template_file.script1.rendered}"

}

#Initial script to run for EC2 instances to create a php file to access the database
data "template_file" "script1" {
  # count = "${var.count}"
  template = <<-EOF
  #!/bin/bash
  apt-get update -y
  apt-get install -y nginx php php-mysqlnd mysql-client php7.0-fpm
  echo "<?php" >> /var/www/html/ibuiltthis.php
  echo "\$conn = new mysqli('${var.dbname}', 'master', 'mastersql', 'mydb');" >> /var/www/html/ibuiltthis.php
  echo "\$sql = 'SELECT * FROM teams'; " >> /var/www/html/ibuiltthis.php
  echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/ibuiltthis.php
  echo "while(\$row = \$result->fetch_assoc()) { echo 'Team : ' . \$row['name'].'<br>'.'----------------------------------------<br>';} " >> /var/www/html/ibuiltthis.php
  echo "\$conn->close(); " >> /var/www/html/ibuiltthis.php
  echo "?>" >> /var/www/html/ibuiltthis.php
  cp /tmp/default /etc/nginx/sites-available/default
  systemctl restart nginx
  EOF
}

#Create an autoscaling group with above created launch configuration
resource "aws_autoscaling_group" "autoscaling" {
  name                 = "autoscaling-webserver"
  launch_configuration = "${aws_launch_configuration.webserver-launch-conf.name}"
  min_size             = 2
  max_size             = 5
  vpc_zone_identifier = ["${var.public-subnet}"]
  load_balancers      = ["${var.elb}"]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  lifecycle {
    create_before_destroy = true
  }
}