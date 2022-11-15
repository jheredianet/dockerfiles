FROM ubuntu:latest
LABEL maintainer="jchm@infoinnova.net"

COPY install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

COPY entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ENV \
    CONFIG="/config/rclone.conf" \
    MOUNTCONFIG="" \
    MOUNTPATH="/Path" \
    CACHE_PATH="/mnt/cache" \
    CACHE_SIZE="100" \
    META_DATA="" \
    MOUNTPOINT="/mnt/mountpoint" \
    TZ="Europe/Madrid"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["mount"]
