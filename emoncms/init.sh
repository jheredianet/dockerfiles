#!/bin/bash
set -e

mkdir -p /var/log/emoncms/
echo "" >> /var/log/emoncms/emoncms.log 
echo "" >> /var/log/emoncms/emonpiupdate.log

#update

git clone https://github.com/emoncms/emoncms.git /var/www/html
git clone https://github.com/emoncms/dashboard.git /var/www/html/Modules/dashboard
git clone https://github.com/emoncms/graph.git /var/www/html/Modules/graph
git clone https://github.com/emoncms/app.git /var/www/html/Modules/app
git clone https://github.com/emoncms/device.git /var/www/html/Modules/device
