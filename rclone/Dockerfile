FROM ubuntu:18.04
LABEL maintainer="jchm@infoinnova.net"

ADD install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

ADD entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

ENV \
    CONFIG="/config/rclone.conf" \
    MOUNTCONFIG="" \
    BUFFER_SIZE="1G" \
    DIR_CACHE_TIME="72h" \
    VFS_READ_CHUNK_SIZE="128M" \
    DRIVE_CHUNK_SIZE="256M" \   
    CACHE_FOLDER="/cache" \
    MOUNTPOINT="/mnt/mountpoint" 

VOLUME ${MOUNTPOINT}

ENTRYPOINT ["/tmp/entrypoint.sh"]
CMD ["mount"]
