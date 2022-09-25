FROM ubuntu:22.04
LABEL maintainer="jchm@infoinnova.net"

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ADD entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ENV \
    RESTIC_PASSWORD="XXXXXXXX" \
    RESTIC_REPOSITORY="rclone:" \
    RESTIC_PACK_SIZE="100" \
    RESTIC_COMPRESSION="off" \
    RCLONE_CONFIG="scripts/rclone.conf" \
    RCLONE_DRIVE_USE_TRASH=false \
    RCLONE_VERBOSE=1 \
    RCLONE_STATS=5m \
    RCLONE_LOG_FILE="/tmp/container.log" \
    RESTIC_CACHE_DIR="/tmp"\
    MOUNTPOINT="/mnt/mountpoint" \
    TZ="Europe/Madrid"

RUN echo "" > "$RCLONE_LOG_FILE"

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["mount"]
