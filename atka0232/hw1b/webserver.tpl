#!/bin/bash
  sleep 130
  sudo apt-get -y update
  sudo apt-get install -y apache2 php libapache2-mod-php php-mcrypt php-mysql
  sudo chmod 777 /var/www/html
  chkconfig apache2 on 
  sudo rm -f /var/www/html/index.html
  echo "<html>" >> /var/www/html/index.html
  echo "<body>" >> /var/www/html/index.html
  echo "<h1>Welcome to Atharva's Webserver!</h1>" >> /var/www/html/index.html
  echo "<h2><a href="mydb.php">Click here to retrieve value from mysql server.</a></h2>" >> /var/www/html/index.html
  echo "</body>" >> /var/www/html/index.html
  echo "</html>" >> /var/www/html/index.html
  echo "<html>" >> /var/www/html/mydb.php
  echo "<body>" >> /var/www/html/mydb.php
  echo "<?php" >> /var/www/html/mydb.php
  echo "\$conn = new mysqli('ip-172-28-3-50.us-west-2.compute.internal', 'root', 'secret', 'test');" >> /var/www/html/mydb.php
  echo "\$sql = 'SELECT * FROM mytable'; " >> /var/www/html/mydb.php
  echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/mydb.php
  echo "while(\$row = \$result->fetch_assoc()) { echo 'Value retrieved from DB: ' . \$row['mycol'] ;} " >> /var/www/html/mydb.php
  echo "\$conn->close(); " >> /var/www/html/mydb.php
  echo "?>" >> /var/www/html/mydb.php
  echo "</body>" >> /var/www/html/mydb.php
  echo "</html>" >> /var/www/html/mydb.php
  sudo systemctl reload apache2

