#!/bin/bash
apt update -y
apt install mysql-client
apt install -y apache2 apache2-doc apache2-utils
apt install -y php php-mysqlnd php7.0-mysql

apt-get install lamp-server^
a2enmod php7.0
service apache2 restart 

chkconfig httpd on
echo "<?php " > /var/www/html/cloudtech.php
echo "\$dbserver = '172.28.3.100';" >> /var/www/html/cloudtech.php
echo "\$username = 'admin';" >> /var/www/html/cloudtech.php 
echo "\$password = 'secret';" >> /var/www/html/cloudtech.php
echo "\$dbname = 'anime';" >> /var/www/html/cloudtech.php
echo "\$conn = new mysqli(\$dbserver, \$username, \$password, \$dbname);" >> /var/www/html/cloudtech.php
echo "\$query = mysqli_query(\$conn,'SELECT * FROM dbz')" >> /var/www/html/cloudtech.php
echo " while (\$row = mysqli_fetch_array(\$query)) " >> /var/www/html/cloudtech.php
echo "   { echo \$row[0] \$row[1]; }" >> /var/www/html/cloudtech.php
echo "?>" >> /var/www/html/cloudtech.php
/etc/init.d/apache2 restart

