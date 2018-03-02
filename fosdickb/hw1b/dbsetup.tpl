#!/bin/bash
apt update -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password dbsecret'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password dbsecret'
apt-get -y install mysql-server
sed -i -e 's/bind-address/#bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf 
service mysql restart

mysql -u root -pdbsecret -e "GRANT ALL PRIVILEGES ON *.* TO 'root@'%' identified by 'dbsecret' WITH GRANT OPTION;"
mysql -u root -pdbsecret -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql -u root -pdbsecret -e "CREATE DATABASE simpledb;"
mysql -u root -pdbsecret -D simpledb -e "CREATE USER 'root'@'%' IDENTIFIED BY 'dbsecret';"
mysql -u root -pdbsecret -D simpledb -e 'CREATE TABLE lab1 (testdata varchar(255));'
mysql -u root -pdbsecret -D simpledb -e "INSERT INTO lab1 (testdata) values ('Hello Cloud Technologies');"
