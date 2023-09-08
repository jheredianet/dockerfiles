FROM ubuntu:latest
LABEL maintainer="@jheredianet"

COPY install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

COPY entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ENV \
    CONFIG="" \
    MOUNTCONFIG="" \
    MOUNTPATH="" \
    CACHE_PATH="/mnt/cache" \
    CACHE_SIZE="50" \
    META_DATA="" \
    JUICEFS_OPTIONS="" \
    RCLONE_OPTIONS="" \
    MOUNTPOINT="/mnt/mountpoint" \
    TZ="Europe/Madrid"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["mount"]
