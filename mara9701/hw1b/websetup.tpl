#!/bin/bash
 sudo su
 apt update -y
 apt install mysql-client
 apt install -y apache2 apache2-doc apache2-utils
 apt install -y php php-mysqlnd php7.0-mysql
 apt install libapache2-mod-php libapache2-mod-php7.0
 service apache2 reload
 service httpd start
 chkconfig httpd on

#Modify DirectoryIndex to point to calldb.php
sudo sed -i 's/.*DirectoryIndex index.html.*$/DirectoryIndex calldb.php index.html/g' /etc/httpd/conf/httpd.conf
echo "<html><h1>Hello! Welcome to Madhavi's page! </h2></html>" > /var/www/html/index.html

echo "<?php" > /var/www/html/cloudtech.php
echo "\$servername = '10.0.16.100';" >> /var/www/html/cloudtech.php
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

service httpd restart
service apache2 reload
