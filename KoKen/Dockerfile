FROM phusion/baseimage:master
LABEL maintainer="jchm@infoinnova.net"

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install required packages
# LANG=C.UTF-8 line is needed for ondrej/php5 repository
RUN \
	export LANG=C.UTF-8 && export LC_ALL=C.UTF-8 && \
	apt-get -yy update && apt-get -yy upgrade && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:ondrej/php -y && \
	apt-get -yy update && \
	apt-get install -y \
		apt-utils \
		nginx \
		mysql-client \
		graphicsmagick ffmpeg pwgen wget unzip && \
	apt-get install -y \
	    php8.0 php8.0-fpm php8.0-mysql php8.0-curl php8.0-mcrypt php8.0-gd \
		php-xmlrpc  \
		libapache2-mod-php8.0 php8.0-fpm libapache2-mod-fcgid php8.0-curl \
		php8.0-dev php8.0-gd php8.0-mbstring php8.0-zip php8.0-mysql php8.0-xml
    # python-software-properties  php-simplexml (seems to be not neccesary)

# Configuration
RUN \
	mkdir -p /run/php && \
	sed -i -e"s/events\s{/events {\n\tuse epoll;/" /etc/nginx/nginx.conf && \
	sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2;\n\tclient_max_body_size 100m;\n\tport_in_redirect off/" /etc/nginx/nginx.conf && \
	echo "daemon off;" >> /etc/nginx/nginx.conf && \
	sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/8.0/fpm/php.ini && \
	sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/8.0/fpm/php.ini && \
	sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 101M/g" /etc/php/8.0/fpm/php.ini && \
	sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/8.0/fpm/php-fpm.conf && \
	sed -i -e "s/;pm.max_requests\s*=\s*500/pm.max_requests = 500/g" /etc/php/8.0/fpm/pool.d/www.conf && \
	echo "env[KOKEN_HOST] = 'koken-docker-lemp'" >> /etc/php/8.0/fpm/pool.d/www.conf && \
	cp /etc/php/8.0/fpm/pool.d/www.conf /etc/php/8.0/fpm/pool.d/images.conf && \
	sed -i -e "s/\[www\]/[images]/" /etc/php/8.0/fpm/pool.d/images.conf && \
    sed -i -e "s#listen\s*=\s*/run/php/php7\.0-fpm\.sock#listen = /run/php/php7\.0-fpm-images.sock#" /etc/php/8.0/fpm/pool.d/images.conf

# nginx site conf
ADD ./conf/nginx-site.conf /etc/nginx/sites-available/default

# Add runit files for each service
ADD ./services/nginx /etc/service/nginx/run
ADD ./services/php-fpm /etc/service/php-fpm/run

# Installation helpers

# Cron

# Startup script
ADD ./shell/start.sh /etc/my_init.d/001_koken.sh

# Execute permissions where needed
RUN \
	chmod +x /etc/service/nginx/run && \
	chmod +x /etc/service/php-fpm/run && \
	chmod +x /etc/my_init.d/001_koken.sh
	
# Data volumes
VOLUME ["/usr/share/nginx/www"]

# Expose
EXPOSE 80 443

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
