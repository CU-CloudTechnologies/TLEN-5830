#!/usr/bin/env bash
set -xe

# update packages
yum -y update

# Install apache, php and mysql
yum -y install epel-release
yum -y install php-fpm php-mysql nginx mysql

# Create website root directory
mkdir -p /var/www/html/

# Edit PHP configuration
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini

sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/user = nginx/g' /etc/php-fpm.d/www.conf

## Build NGINX Configuration
echo "
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] \"$request\" '
                      '$status $body_bytes_sent \"$http_referer\" '
                      '\"$http_user_agent\" \"$http_x_forwarded_for\"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
} 
" > /etc/nginx/nginx.conf

echo "
#
# The default server
#
server {
    listen       80;
    server_name `hostname`;

   
    location / {
        root   /var/www/html;
        index index.php  index.html index.htm;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        root           /var/www/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME   \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
    }
}
" >> /etc/nginx/conf.d/default.conf