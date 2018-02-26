#!/bin/bash
sleep 120
sudo yum update -y
sudo yum install -y mysql55-server
sudo service mysqld start
sudo /usr/bin/mysqladmin -u root password 'amrita'
sudo mysql -u root -pamrita -e "create user 'root'@'%' identified by 'amrita';" mysql
sudo mysql -u root -pamrita -e 'CREATE TABLE cloud (mycol varchar(255));' test
sudo mysql -u root -pamrita -e "INSERT INTO cloud (mycol) values ('Hello Cloud Technologies') ;" test
