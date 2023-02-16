FROM ubuntu:22.04
LABEL maintainer="@jheredianet"

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ADD entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ENV \
    HOURS_RCLONE_MOVE="6h" \
    CONFIG="/config/rclone.conf" \
    MOUNTCONFIG="RCLONECONFIGNAME" \
    MOUNTPATH="/Path" \
    LOGFILE="/mnt/cache/rclone-mount.log" \
    BASIC_FLAGS="--user-agent=rclone --umask=002 --gid=1000 --uid=1000 --timeout=1h --log-level=INFO" \
    OTHER_FLAGS="--timeout=1h --poll-interval=15s --dir-cache-time=1000h --vfs-cache-mode=full --vfs-cache-max-size=100G --vfs-cache-max-age=24h" \
    LOCAL_FOLDER="/mnt/local" \
    CACHE_FOLDER="/mnt/cache" \
    CLONE_FOLDER="/mnt/rclone" \
    MOUNTPOINT="/mnt/mountpoint" 

RUN mkdir -p "$CACHE_FOLDER" && echo "" > "$LOGFILE"

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/setup/entrypoint.sh"]
CMD ["mount"]
