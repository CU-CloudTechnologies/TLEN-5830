#!/bin/bash
sleep 150  
yum update -y
yum install -y httpd24 php56 php56-mysqlnd
service httpd start
chkconfig httpd on

echo "<?php" >> /var/www/html/cloudtech.php
echo "\$conn = new mysqli('ip-172-17-4-200.us-west-2.compute.internal', 'root', 'amrita', 'test');" >> /var/www/html/cloudtech.php
echo "\$sql = 'SELECT * FROM cloud'; " >> /var/www/html/cloudtech.php
echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/cloudtech.php
echo "while(\$row = \$result->fetch_assoc()) { echo \$row['mycol'] ;} " >> /var/www/html/cloudtech.php
echo "\$conn->close(); " >> /var/www/html/cloudtech.php
echo "?>" >> /var/www/html/cloudtech.php
