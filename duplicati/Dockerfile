FROM linuxserver/duplicati
LABEL maintainer="jchm@infoinnova.net"

RUN apt update -yy && apt install man -yy
RUN curl https://rclone.org/install.sh | bash
RUN mkdir -p /config/files/ && ln -s /config/.config/rclone/rclone.conf /config/files/rclone.conf
