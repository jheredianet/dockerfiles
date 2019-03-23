FROM ubuntu:18.04
LABEL maintainer="jchm@infoinnova.net"

COPY install.sh /install.sh
RUN chmod +x /install.sh
RUN /install.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

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

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mount"]
