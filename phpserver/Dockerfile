FROM php:apache-bookworm
LABEL maintainer="@jheredianet"

RUN apt update -yy && apt upgrade -yy
RUN apt install -yy iputils-ping iproute2 curl wget nload dnsutils htop iperf3 nano

COPY ports.conf /etc/apache2/ports.conf
COPY index.php /var/www/html/index.php

EXPOSE 8888
EXPOSE 4444