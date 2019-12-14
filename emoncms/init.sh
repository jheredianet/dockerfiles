#!/bin/bash
set -e

mkdir -p /var/log/emoncms/
echo "" >> /var/log/emoncms/emoncms.log 
echo "" >> /var/log/emoncms/emonpiupdate.log

# update from git

cd /var/www/html && git pull origin master
cd /var/www/html/Modules/dashboard && git pull origin master
cd /var/www/html/Modules/graph && git pull origin master
cd /var/www/html/Modules/app && git pull origin master
cd /var/www/html/Modules/device && git pull origin master

tail -f /var/log/emoncms/emoncms.log & wait