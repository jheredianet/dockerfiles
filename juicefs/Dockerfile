FROM ubuntu:latest
LABEL maintainer="@jheredianet"

COPY install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

COPY entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ENV \
    CONFIG="/config/rclone.conf" \
    MOUNTCONFIG="dataTD" \
    MOUNTPATH="/path" \
    CACHE_PATH="/mnt/cache" \
    CACHE_SIZE="50" \
    META_DATA="" \
    JUICEFS_OPTIONS="" \
    RCLONE_OPTIONS="--vfs-cache-mode=full --transfers 32 --checkers 32" \
    MOUNTPOINT="/mnt/mountpoint" \
    TZ="Europe/Madrid"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["mount"]
