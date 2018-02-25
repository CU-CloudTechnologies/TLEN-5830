#!/bin/sh

db_server=$1

`ls -l /etc/httpd > /dev/null 2>&1`
if [ $? -eq 0 ]
then
	echo "
export DB_HOST='$db_server'
export DB_USER='cloudtech'
export DB_PASSWORD='Super123'
" >> /etc/sysconfig/httpd

	service httpd restart
	chkconfig httpd on
fi

`ls -l /etc/nginx > /dev/null 2>&1`

if [ $? -eq 0 ]
then
	echo "
env[DB_HOST] = '$db_server'
env[DB_USER] = 'cloudtech'
env[DB_PASSWORD] = 'Super123'
" >> /etc/php-fpm.d/www.conf

	service php-fpm restart
    service nginx restart
    chkconfig php-fpm on
    chkconfig nginx on
fi