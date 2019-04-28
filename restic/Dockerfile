FROM ubuntu:18.04
LABEL maintainer="jchm@infoinnova.net"

ADD entrypoint.sh /setup/entrypoint.sh
RUN chmod +x /setup/entrypoint.sh

ADD restic_0.9.4_linux_amd64 /setup/restic
RUN chmod +x /setup/restic
RUN mv /setup/restic /usr/bin/restic

ADD install.sh /setup/install.sh
RUN chmod +x /setup/install.sh
RUN /setup/install.sh

ENV \
    RCLONE_CONFIG="/config/rclone.conf" \
    CACHE_FOLDER="/mnt/cache" \
    RCLONE_LOG_FILE="/mnt/cache/rclone.log" \
    RESTIC_PASSWORD="MyPaSSw0rd" \
    RESTIC_REPOSITORY="rest:http://localhost:8080/" \
    RCLONE_PARAMETERS="" \
    MOUNTCONFIG="cache-rclone" \
    SERVERPATH="backuprepo" \
    MOUNTPOINT="/mnt/mountpoint" 

VOLUME ${MOUNTPOINT}
VOLUME "/config"

ENTRYPOINT ["/setup/entrypoint.sh"]
#CMD ["/bin/bash"]
