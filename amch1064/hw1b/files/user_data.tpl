#cloud-config
runcmd:
- sudo wget https://${s3_bucket}/lab1.php -O /var/www/html/lab1.php
- sudo wget https://${s3_bucket}/table.sql -O ${db_table_file}
- sudo wget https://s3.amazonaws.com/cloud-tech-config/service-init.sh -O /tmp/service-init.sh
- sudo bash /tmp/service-init.sh ${db_server}
- mysql -u cloudtech -pSuper123 lab1db -h ${db_server} < ${db_table_file};
- echo "INSERT INTO labs (name,author) VALUES ('Lab 1','Amar Chaudhari');" | mysql -u cloudtech -pSuper123 lab1db -h ${db_server};