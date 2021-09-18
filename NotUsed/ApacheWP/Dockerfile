#FROM php:5.6-apache
FROM php:7.0-apache
RUN apt-get update
RUN apt-get -y install libmcrypt-dev php5-mysql php5-curl libfreetype6-dev libjpeg62-turbo-dev libpng12-dev
RUN docker-php-ext-install -j$(nproc) mysqli iconv mcrypt
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 
RUN docker-php-ext-install -j$(nproc) gd

# Habilitando módulos para wordpress
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod headers

CMD ["apache2-foreground"]

#
#FROM php:7.0-fpm
#RUN apt-get update && apt-get install -y \
#        libfreetype6-dev \
#        libjpeg62-turbo-dev \
#        libmcrypt-dev \
#        libpng12-dev \
#    && docker-php-ext-install -j$(nproc) iconv mcrypt \
#    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#    && docker-php-ext-install -j$(nproc) gd