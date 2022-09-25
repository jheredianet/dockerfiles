FROM ubuntu:22.04
LABEL maintainer="jchm@infoinnova.net"

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ADD entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ENV RESTIC_CACHE_DIR="/mnt/cache"
ENV \
    RESTIC_PASSWORD="XXXXXXXX" \
    RESTIC_REPOSITORY="rclone:" \
    RESTIC_PACK_SIZE="100" \
    RESTIC_COMPRESSION="off" \
    RCLONE_CONFIG="/config/rclone.conf" \
    RCLONE_LOG_FILE="$RESTIC_CACHE_DIR/container.log" \ 
    RCLONE_DRIVE_USE_TRASH=false \
    RCLONE_VERBOSE=1 \
    RCLONE_STATS=5m \
    MOUNTPOINT="/mnt/mountpoint" \
    TZ="Europe/Madrid"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -p "$RESTIC_CACHE_DIR" && echo "" > "$RCLONE_LOG_FILE"

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["mount"]
