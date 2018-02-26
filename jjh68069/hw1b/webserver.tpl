#!/bin/bash
apt update -y
apt install mysql-client
apt install -y apache2 apache2-doc apache2-utils
apt install -y php php-mysqlnd php7.0-mysql
service httpd start
chkconfig httpd on

echo "True" > /var/www/html/healthy.html
echo "<?php" > /var/www/html/cloudtech.php
echo "\$servername = '10.0.16.100';" >> /var/www/html/cloudtech.php
echo "\$username = 'jason';" >> /var/www/html/cloudtech.php 
echo "\$password = 'H3ll0world!';" >> /var/www/html/cloudtech.php
echo "\$dbname = 'simpledb';" >> /var/www/html/cloudtech.php
echo "\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);" >> /var/www/html/cloudtech.php
echo "\$query = mysqli_query(\$conn,'SELECT * FROM lab1')" >> /var/www/html/cloudtech.php
echo "    or die (mysqli_fetch_error(\$query));" >> /var/www/html/cloudtech.php
echo "while (\$row = mysqli_fetch_array(\$query)) {" >> /var/www/html/cloudtech.php
echo "    echo \$row['testdata'];" >> /var/www/html/cloudtech.php
echo "}" >> /var/www/html/cloudtech.php
echo "?>" >> /var/www/html/cloudtech.php

/etc/init.d/apache2 restart