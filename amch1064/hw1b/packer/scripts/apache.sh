#!/usr/bin/env bash
set -xe

# update packages
yum -y update

# Install apache, php and mysql
yum -y install epel-release
yum -y install php php-mysql httpd mysql
