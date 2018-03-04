#Create two EC2 instances
variable "count" {
  default = 2
}

#Create EC2 instances with an init script
resource "aws_instance" "webserver" {
  ami = "${var.ami}"
  instance_type = "${var.instance-type}"
  associate_public_ip_address = "true"
  subnet_id = "${var.public-subnet}"
  vpc_security_group_ids = ["${var.security-group-webserver}"]
  key_name = "${var.key-name}"
  count = "${var.count}"
  tags {
        Name = "webserver-${count.index}"
  }

#  user_data = "${element(concat(data.template_file.script1.*.rendered, data.template_file.script2.*.rendered), 0)}"
  user_data = <<-EOF
  #!/bin/bash
  apt-get update -y
  apt-get install -y nginx php php-mysqlnd mysql-client php7.0-fpm
  SQL="CREATE TABLE teams (name VARCHAR(20));INSERT INTO teams (name) VALUES ('Chelsea FC');INSERT INTO teams (name) VALUES ('FC Barcelona');"
  mysql -h ${aws_db_instance.database.address} -umaster -pmastersql mydb -e "$SQL"  
  echo "<?php" >> /var/www/html/ibuiltthis.php
  echo "echo 'SERVER - ${count.index} <br> ----------------------------------------<br>';" >> /var/www/html/ibuiltthis.php
  echo "\$conn = new mysqli('${aws_db_instance.database.address}', 'master', 'mastersql', 'mydb');" >> /var/www/html/ibuiltthis.php
  echo "\$sql = 'SELECT * FROM teams'; " >> /var/www/html/ibuiltthis.php
  echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/ibuiltthis.php
  echo "while(\$row = \$result->fetch_assoc()) { echo 'Team : ' . \$row['name'].'<br>'.'----------------------------------------<br>';} " >> /var/www/html/ibuiltthis.php
  echo "\$conn->close(); " >> /var/www/html/ibuiltthis.php
  echo "?>" >> /var/www/html/ibuiltthis.php
  cp /tmp/default /etc/nginx/sites-available/default
  systemctl restart nginx
  EOF


  provisioner "file" {
    source = "default"
    destination = "/tmp/default"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${var.ssh-key-file}"
#      private_key = "${file("terraform.pem")}"   
    }
  }
}

data "template_file" "script2" {
  template = <<-EOF
  #!/bin/bash
  SQL="CREATE TABLE teams (name VARCHAR(20));INSERT INTO teams (name) VALUES ('Chelsea FC');INSERT INTO teams (name) VALUES ('FC Barcelona');"
  mysql -h ${aws_db_instance.database.address} -umaster -pmastersql mydb -e "$SQL"
  EOF
}

output "public_ip" {
  value = "${aws_instance.webserver.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.webserver.*.public_dns}"
}