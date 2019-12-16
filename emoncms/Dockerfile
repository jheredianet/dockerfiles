# Offical Docker PHP & Apache image https://hub.docker.com/_/php/
FROM php:7.0-apache

# Install deps
RUN apt-get update && apt-get install -y \
              libcurl4-gnutls-dev \
              libmcrypt-dev \
              libmosquitto-dev \
              git-core

# Enable PHP modules
RUN docker-php-ext-install -j$(nproc) mysqli curl json mcrypt gettext
RUN pecl install redis-3.1.6 \
  \ && docker-php-ext-enable redis
RUN pecl install Mosquitto-0.4.0 \
  \ && docker-php-ext-enable mosquitto

RUN a2enmod rewrite

# Add custom PHP config
COPY config/php.ini /usr/local/etc/php/

# NOT USED ANYMORE - GIT CLONE INSTEAD
# Copy in emoncms files, files can be mounted from local FS for dev see docker-compose
# ADD ./emoncms /var/www/html

# Clone in master Emoncms repo & modules - overwritten in development with local FS files
RUN git clone https://github.com/emoncms/emoncms.git /var/www/html
RUN git clone https://github.com/emoncms/dashboard.git /var/www/html/Modules/dashboard
RUN git clone https://github.com/emoncms/graph.git /var/www/html/Modules/graph
RUN git clone https://github.com/emoncms/app.git /var/www/html/Modules/app
RUN git clone https://github.com/emoncms/device.git /var/www/html/Modules/device

COPY docker.settings.php /var/www/html/settings.php

# Create folders & set permissions for feed-engine data folders (mounted as docker volumes in docker-compose)
RUN mkdir /var/lib/phpfiwa
RUN mkdir /var/lib/phpfina
RUN mkdir /var/lib/phptimeseries
RUN chown www-data:root /var/lib/phpfiwa
RUN chown www-data:root /var/lib/phpfina
RUN chown www-data:root /var/lib/phptimeseries

## JCH, now in init.sh
# Create Emoncms logfile
RUN mkdir -p /var/log/emoncms/
RUN touch /var/log/emoncms/emoncms.log && touch /var/log/emoncms/emonpiupdate.log
RUN chmod -R 666 /var/log/emoncms/

# Default docker enviroment variables, change in production enviroment

# MySQL database 
ENV \
MYSQL_HOST=xxxx \
MYSQL_PORT=3306 \
MYSQL_DATABASE=xxxx \
MYSQL_USER=xxxx \
MYSQL_PASSWORD=xxxx \
MYSQL_RANDOM_ROOT_PASSWORD=no

# Redis
# At the moment Docker doesn't honour the REDIS_AUTH variable, so it will always be passwordless
# REDIS_AUTH=
ENV \
REDIS_ENABLED=true \
REDIS_HOST=redis \
REDIS_PORT=6379 \
REDIS_PREFIX='emoncms'

# MQTT
ENV \
MQTT_ENABLED=false \
MQTT_HOST=localhost \
MQTT_PORT=1883 \
MQTT_USER=YOUR_MQTT_USER \
MQTT_PASSWORD=YOUR_MQTT_PASSWORD \
MQTT_BASETOPIC=emon
