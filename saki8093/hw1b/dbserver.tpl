#!/bin/bash
apt update -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password secret'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password secret'
apt-get -y install mysql-server
sed -i -e 's/bind-address/#bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf 
service mysql restart


mysql -u root -psecret -e "CREATE DATABASE anime;"
mysql -u root -psecret -e "GRANT ALL PRIVILEGES ON anime.* TO 'root'@'%' identified by 'secret' WITH GRANT OPTION;"
mysql -u root -psecret -e "GRANT ALL PRIVILEGES ON anime.* TO 'admin'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql -u root -psecret -D anime -e "CREATE USER 'root'@'%' IDENTIFIED BY 'secret';"
mysql -u root -psecret -D anime -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'secret';"
mysql -u root -psecret -D anime -e 'CREATE TABLE dbz (Name varchar(255), Powerlevel int);'
mysql -u root -psecret -D anime -e "INSERT INTO dbz (Name,Powerlevel) values ('Goku', 10000);"
mysql -u root -psecret -D anime -e "INSERT INTO dbz (Name,Powerlevel) values ('Vegeta', 9000);"

